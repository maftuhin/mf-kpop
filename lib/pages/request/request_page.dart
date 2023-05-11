import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kpop_lyrics/repository/request_repository.dart';
import 'package:kpop_lyrics/utils/ad_helper.dart';
import 'package:line_icons/line_icons.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  int _interstitialAttempts = 0;

  final txtArtist = TextEditingController();
  final txtTitle = TextEditingController();

  @override
  void initState() {
    _loadBannerAd();
    _createInterstitialAd();
    super.initState();
  }

  void _loadBannerAd() {
    BannerAd(
      size: AdSize.banner,
      adUnitId: AdHelper.bannerRequestAdUnitId,
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
      ),
      request: const AdRequest(),
    ).load();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnit,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialAttempts = 0;
          _interstitialAd?.setImmersiveMode(true);
        },
        onAdFailedToLoad: (error) {
          _interstitialAttempts += 1;
          _interstitialAd = null;
          if (_interstitialAttempts < 3) {
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
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _createInterstitialAd();
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        context.pop();
      },
    );
    _interstitialAd?.show();
    _interstitialAd = null;
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("REQUEST"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: txtArtist,
              decoration: const InputDecoration(
                prefixIcon: Icon(LineIcons.user),
                hintText: "Artist"
              ),
            ),
            TextField(
              controller: txtTitle,
              decoration: const InputDecoration(
                prefixIcon: Icon(LineIcons.music),
                hintText: "Title"
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => sendRequest(),
              child: const Text("SEND"),
            )
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: AdSize.banner.height.toDouble(),
        child: _bannerAd != null
            ? AdWidget(ad: _bannerAd!)
            : const Center(child: Text("Google Ads")),
      ),
    );
  }

  Future<void> sendRequest() async {
    if (txtArtist.text.isNotEmpty || txtTitle.text.isNotEmpty) {
      final result = await RequestRepository().sendRequest(
        txtArtist.text,
        txtTitle.text,
      );
      if (result.message == "Thank you") {
        _showInterstitialAd();
        txtArtist.clear();
        txtTitle.clear();
      }
    }
  }
}
