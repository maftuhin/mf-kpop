import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:kpop_lyrics/models/m_song.dart';
import 'package:kpop_lyrics/repository/song_repository.dart';
import 'package:kpop_lyrics/utils/debouncer.dart';

class SearchLyricPage extends StatefulWidget {
  const SearchLyricPage({super.key});

  @override
  State<SearchLyricPage> createState() => _SearchLyricPageState();
}

class _SearchLyricPageState extends State<SearchLyricPage> {
  final PagingController<int, MSong> _pagingController =
      PagingController(firstPageKey: 0);
  final query = TextEditingController();

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      SongRepository().search(_pagingController, query.text, pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final debouncer = Debouncer(miliseconds: 1000);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: SearchBar(
            leading: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(FluentIcons.search_12_regular),
            ),
            hintText: "search here",
            controller: query,
            onChanged: (value) => debouncer.run(() {
              _pagingController.refresh();
            }),
          ),
        ),
        Expanded(
          child: PagedListView<int, MSong>.separated(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate(
              itemBuilder: (context, item, index) {
                return _LyricItem(item: item);
              },
            ),
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(height: 0.0),
          ),
        )
      ],
    );
  }
}

class _LyricItem extends StatelessWidget {
  final MSong item;
  const _LyricItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.title ?? ""),
      subtitle: Text(item.artist ?? ""),
      leading: const CircleAvatar(child: Icon(FluentIcons.music_note_2_play_20_regular)),
      trailing: Chip(label: Text("${item.view} view")),
      onTap: () {
        context.push("/lyric/${item.uid}");
      },
    );
  }
}
