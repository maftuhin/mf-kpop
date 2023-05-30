import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kpop_lyrics/models/m_artist.dart';
import 'package:kpop_lyrics/repository/artist_repository.dart';
import 'package:kpop_lyrics/utils/debouncer.dart';
import 'package:line_icons/line_icons.dart';

class SearchArtistPage extends StatefulWidget {
  const SearchArtistPage({super.key});

  @override
  State<SearchArtistPage> createState() => _SearchArtistPageState();
}

class _SearchArtistPageState extends State<SearchArtistPage> {
  final PagingController<int, MArtist> _pagingController =
      PagingController(firstPageKey: 1);
  final TextEditingController query = TextEditingController();

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      doSearch(pageKey);
    });
    super.initState();
  }

  void doSearch(int pageKey) {
    ArtistRepository().search(_pagingController, query.text, pageKey);
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
              child: Icon(LineIcons.search),
            ),
            hintText: "search here",
            controller: query,
            onChanged: (value) => debouncer.run(() {
              _pagingController.refresh();
            }),
          ),
        ),
        Expanded(
          child: PagedListView<int, MArtist>.separated(
            separatorBuilder: (context, index) => const Divider(height: 0.0),
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate(
              itemBuilder: (context, item, index) {
                return _ArtistItem(item: item);
              },
            ),
          ),
        )
      ],
    );
  }
}

class _ArtistItem extends StatelessWidget {
  final MArtist item;
  const _ArtistItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        child: Icon(FluentIcons.person_16_regular),
      ),
      title: Text(item.name ?? ""),
      onTap: () {
        context.push("/artist/${item.code}", extra: item);
      },
    );
  }
}
