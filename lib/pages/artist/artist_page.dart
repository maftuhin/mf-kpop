import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kpop_lyrics/models/m_artist.dart';
import 'package:kpop_lyrics/models/m_song.dart';
import 'package:kpop_lyrics/repository/song_repository.dart';
import 'package:kpop_lyrics/utils/ad_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArtistPage extends StatefulWidget {
  final MArtist? artist;
  const ArtistPage({super.key, this.artist});

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  final PagingController<int, MSong> _pagingController =
      PagingController(firstPageKey: 0);
  BannerAd? _bannerAd;
  String? imageBackground;
  var isSubscribe = false;

  @override
  void initState() {
    BannerAd(
      size: AdSize.banner,
      adUnitId: AdHelper.bannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    ).load();
    _pagingController.addPageRequestListener((pageKey) {
      SongRepository()
          .songByArtist(_pagingController, widget.artist?.code ?? "", pageKey);
    });
    subsStatus();
    getImage();
    super.initState();
  }

  Future<void> getImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var image = prefs.getString("image-${widget.artist?.code}");
    var isImageExist = await File(image.toString()).exists();
    if (isImageExist) {
      setState(() {
        imageBackground = image;
      });
    }
  }

  Future<void> pickImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(
          "image-${widget.artist?.code}", result.files.single.path.toString());
      getImage();
    }
  }

  void subsStatus() {
    var box = Hive.box("notifications");
    var data = box.get(widget.artist?.code);
    if (data != null && data["subs"] == true) {
      setState(() {
        isSubscribe = true;
      });
    } else {
      setState(() {
        isSubscribe = false;
      });
    }
  }

  Future<void> handleSubscription() async {
    var notification = Hive.box("notifications");
    var artist = widget.artist;
    var data = notification.get(artist?.code ?? "");
    if (data != null && data["subs"] == true) {
      setState(() {
        isSubscribe = false;
      });
      await FirebaseMessaging.instance.unsubscribeFromTopic(artist?.code ?? "");
    } else {
      setState(() {
        isSubscribe = true;
      });
      await FirebaseMessaging.instance.subscribeToTopic(artist?.code ?? "");
    }
    notification.put(artist?.code, {
      "name": artist?.name,
      "code": artist?.code,
      "subs": isSubscribe,
    });
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height / 3,
              floating: false,
              pinned: true,
              actions: [
                IconButton(
                  onPressed: () => handleSubscription(),
                  icon: Icon(
                    isSubscribe
                        ? FluentIcons.alert_off_16_regular
                        : FluentIcons.alert_16_regular,
                  ),
                ),
                IconButton(
                  onPressed: () => pickImage(),
                  icon: const Icon(FluentIcons.image_16_regular),
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  widget.artist?.name ?? "",
                  style: Theme.of(context).textTheme.titleMedium,
                ).animate().shake(),
                background: imageBackground != null
                    ? Image.file(
                        File(imageBackground.toString()),
                        fit: BoxFit.cover,
                      )
                    : Container(),
              ),
            )
          ];
        },
        body: PagedListView<int, MSong>.separated(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate(
            itemBuilder: (context, item, index) {
              return _SongItem(item);
            },
          ),
          separatorBuilder: (context, index) => const Divider(height: 0.0),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push("/community/${widget.artist?.code}",
              extra: widget.artist);
        },
        child: const Icon(FluentIcons.chat_12_regular),
      ),
      bottomNavigationBar: SizedBox(
        height: AdSize.banner.height.toDouble(),
        child: _bannerAd != null
            ? AdWidget(ad: _bannerAd!)
            : const Center(child: Text("Google Ads")),
      ),
    );
  }
}

class _SongItem extends StatelessWidget {
  final MSong item;
  const _SongItem(this.item);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(FluentIcons.music_note_2_play_20_regular),
      title: Text(item.title ?? ""),
      trailing: Chip(label: Text("${item.view} view")),
      onTap: () {
        context.push("/lyric/${item.uid}");
      },
    );
  }
}
