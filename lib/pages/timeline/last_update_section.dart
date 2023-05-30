import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kpop_lyrics/models/m_song.dart';
import 'package:kpop_lyrics/repository/song_repository.dart';
import 'package:line_icons/line_icons.dart';

final repoProvider = Provider((ref) => SongRepository());
final latestProvider = FutureProvider.autoDispose(
  (ref) => ref.read(repoProvider).latest(),
);

class LastUpdateSection extends ConsumerWidget {
  const LastUpdateSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latest = ref.watch(latestProvider);

    return latest.when(
      data: (data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Last Update",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ListView.separated(
              separatorBuilder: (context, index) => const Divider(height: 0.0),
              itemBuilder: (context, index) {
                final item = data[index];
                return _LastUpdateItem(item: item);
              },
              itemCount: data.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            )
          ],
        );
      },
      error: (error, stackTrace) => Container(),
      loading: () => Container(),
    );
  }
}

class _LastUpdateItem extends StatelessWidget {
  final MSong item;
  const _LastUpdateItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(FluentIcons.music_note_2_play_20_regular),
      title: Text(item.title ?? ""),
      subtitle: Text(item.artist ?? ""),
      trailing: Chip(
        label: Text("${item.view} view"),
      ),
      onTap: () {
        context.push("/lyric/${item.uid}");
      },
    );
  }
}
