import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kpop_lyrics/models/m_song.dart';
import 'package:kpop_lyrics/repository/song_repository.dart';
import 'package:kpop_lyrics/utils/ad_helper.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioView extends StatefulWidget {
  final MSong data;
  const AudioView({super.key, required this.data});

  @override
  State<AudioView> createState() => _AudioViewState();
}

class _AudioViewState extends State<AudioView> {
  final _player = AudioPlayer();
  bool isPlaying = false;
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  Timer? _timerCounter;

  @override
  void initState() {
    _countView();
    _createInterstitialAd();
    getAudioPath();
    _player.playerStateStream.listen((event) {
      switch (event.processingState) {
        case ProcessingState.completed:
          setState(() {
            isPlaying = false;
          });
          _player.seek(Duration.zero);
          _player.pause();
          _showInterstitialAd();
          break;
        default:
          break;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _player.dispose();
    _interstitialAd?.dispose();
    _timerCounter?.cancel();
    super.dispose();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnit,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          _interstitialAd?.setImmersiveMode(true);
        },
        onAdFailedToLoad: (error) {
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts < 3) {
            _createInterstitialAd();
          }
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      return;
    }
    _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {},
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd?.show();
    _interstitialAd = null;
  }

  void _countView() {
    _timerCounter = Timer(const Duration(seconds: 10), () {
      SongRepository().counterView(widget.data.id ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.data;
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: Colors.green),
      ),
      height: 80.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(onPressed: () {}, icon: const Icon(LineIcons.music)),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title ?? "",
                  style: Theme.of(context).textTheme.titleMedium,
                ).animate().shake(),
                Text(
                  item.artist ?? "",
                  style: Theme.of(context).textTheme.titleSmall,
                )
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              playOrPickFile();
            },
            icon: const Icon(LineIcons.folderPlus),
          ),
          IconButton(
            onPressed: () async {
              if (isPlaying) {
                setState(() {
                  isPlaying = false;
                });
                await _player.pause();
              } else {
                check();
              }
            },
            icon: Icon(isPlaying ? LineIcons.pause : LineIcons.play),
          ),
        ],
      ),
    );
  }

  Future<void> check() async {
    final playerDuration = _player.duration?.inSeconds;
    if (playerDuration != null && playerDuration > 0) {
      setState(() {
        isPlaying = true;
      });
      await _player.play();
    } else {
      playOrPickFile();
    }
  }

  Future<void> playOrPickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["mp4", "mp3"]);
    if (result != null) {
      File file = File(result.files.single.path.toString());
      _player.setFilePath(file.path);
      savePathToPreferences(file.path);
      setState(() {
        isPlaying = true;
      });
      await _player.play();
    }
  }

  Future<void> savePathToPreferences(String path) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(widget.data.uid ?? "", path);
  }

  Future<void> getAudioPath() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(widget.data.uid ?? "");
    final fileExist = await File(path.toString()).exists();
    if (path != null && fileExist) {
      _player.setFilePath(path);
      setState(() {
        isPlaying = true;
      });
      await _player.play();
    }
  }
}
