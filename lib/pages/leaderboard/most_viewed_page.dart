import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:kpop_lyrics/models/m_song.dart';
import 'package:kpop_lyrics/pages/leaderboard/widget/item_color.dart';
import 'package:kpop_lyrics/repository/song_repository.dart';

class MostViewedPage extends StatefulWidget {
  const MostViewedPage({super.key});

  @override
  State<MostViewedPage> createState() => _MostViewedPageState();
}

class _MostViewedPageState extends State<MostViewedPage> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    _createBannerAd();
    super.initState();
  }

  void _createBannerAd() {
    BannerAd(
      size: AdSize.banner,
      adUnitId: "ca-app-pub-9691140516799861/5766927805",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Most Viewed"),
      ),
      body: const _MostViewedList(),
      bottomNavigationBar: SizedBox(
        height: AdSize.banner.height.toDouble(),
        child: _bannerAd != null
            ? AdWidget(ad: _bannerAd!)
            : const Center(child: Text("Google Ads")),
      ),
    );
  }
}

final repoProvider = Provider((ref) => SongRepository());
final dataProvider = FutureProvider.autoDispose(
  (ref) => ref.read(repoProvider).mostViewed(),
);

class _MostViewedList extends ConsumerWidget {
  const _MostViewedList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(dataProvider).when(
          data: (data) {
            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(height: 0.0),
              itemBuilder: (context, index) {
                final item = data[index];
                return _MostViewedItem(index, item);
              },
              itemCount: data.length,
            );
          },
          error: (error, stackTrace) {
            return Center(child: Text(error.toString()));
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        );
  }
}

class _MostViewedItem extends StatelessWidget {
  final int index;
  final MSong item;
  const _MostViewedItem(this.index, this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context.push("/lyric/${item.uid}");
      },
      leading: CircleAvatar(
        backgroundColor: Color(ItemColor.color[index]),
        child: Text((index + 1).toString()),
      ),
      title: Text(item.title ?? ""),
      subtitle: Text(item.artist ?? ""),
      trailing: Chip(label: Text("${item.view} view")),
    );
  }
}
