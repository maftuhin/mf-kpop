import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kpop_lyrics/models/m_track.dart';
import 'package:kpop_lyrics/repository/ost_repository.dart';
import 'package:line_icons/line_icons.dart';

class SearchSoundtrackPage extends StatefulWidget {
  const SearchSoundtrackPage({super.key});

  @override
  State<SearchSoundtrackPage> createState() => _SearchSoundtrackPageState();
}

class _SearchSoundtrackPageState extends State<SearchSoundtrackPage> {
  final PagingController<int, MTrack> _pageController =
      PagingController(firstPageKey: 0);
  final query = TextEditingController();

  @override
  void initState() {
    _pageController.addPageRequestListener((pageKey) {
      OstRepository().search(query.text, pageKey, _pageController);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            onChanged: (value) {
              _pageController.refresh();
            },
          ),
        ),
        Expanded(
          child: PagedListView<int, MTrack>.separated(
            pagingController: _pageController,
            builderDelegate: PagedChildBuilderDelegate(
              itemBuilder: (context, item, index) {
                return _SoundtrackItem(item: item);
              },
            ),
            separatorBuilder: (context, index) => const Divider(height: 0.0),
          ),
        )
      ],
    );
  }
}

class _SoundtrackItem extends StatelessWidget {
  final MTrack item;
  const _SoundtrackItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: item.image?.isNotEmpty == true
          ? CircleAvatar(
              backgroundImage: NetworkImage(item.image ?? ""),
            )
          : const CircleAvatar(child: Icon(LineIcons.film)),
      title: Text(item.title ?? ""),
      onTap: () {
        context.push("/soundtrack/${item.uid}", extra: item);
      },
    );
  }
}
