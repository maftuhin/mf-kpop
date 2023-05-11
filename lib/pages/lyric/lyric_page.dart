import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:kpop_lyrics/pages/lyric/audio_view.dart';
import 'package:kpop_lyrics/repository/song_repository.dart';
import 'package:kpop_lyrics/utils/mf_util.dart';
import 'package:line_icons/line_icons.dart';

final repoProvider = Provider((ref) => SongRepository());
final songProvider = FutureProvider.family.autoDispose(
  (ref, String uid) => ref.read(repoProvider).detail(uid),
);

class LyricPage extends ConsumerWidget {
  final String? uid;
  const LyricPage(this.uid, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final song = ref.watch(songProvider(uid ?? ""));
    return song.when(
      data: (data) {
        return DefaultTabController(
          length: data.length,
          child: Scaffold(
            appBar: AppBar(
              title: const Text("LYRIC DETAIL"),
              bottom: TabBar(
                isScrollable: data.length > 2,
                tabs: data
                    .map((e) => Tab(text: e.language?.toUpperCase() ?? ""))
                    .toList(),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    final item = data.first;
                    var box = Hive.box("bookmarks");
                    box.put(item.uid, item.toMap());
                  },
                  icon: const Icon(LineIcons.bookmark),
                )
              ],
            ),
            body: TabBarView(
              children: data
                  .map(
                    (e) => SingleChildScrollView(
                      padding: const EdgeInsets.all(12.0),
                      child: SelectableText(
                        MFUtil().replace(e.lyric),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                  .toList(),
            ),
            bottomNavigationBar: AudioView(data: data.first),
          ),
        );
      },
      error: (error, stackTrace) => Scaffold(
        body: Center(child: Text(error.toString())),
      ),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
