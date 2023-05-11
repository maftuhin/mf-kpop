import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kpop_lyrics/models/m_song.dart';
import 'package:kpop_lyrics/models/m_track.dart';
import 'package:kpop_lyrics/repository/ost_repository.dart';
import 'package:line_icons/line_icons.dart';

class SoundtrackPage extends StatefulWidget {
  final MTrack data;
  const SoundtrackPage({super.key, required this.data});

  @override
  State<SoundtrackPage> createState() => _SoundtrackPageState();
}

class _SoundtrackPageState extends State<SoundtrackPage> {
  final PagingController<int, MSong> _pageController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pageController.addPageRequestListener((pageKey) {
      OstRepository()
          .soundtrackList(widget.data.uid ?? "", pageKey, _pageController);
    });
    super.initState();
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
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(widget.data.title ?? "").animate().shake(),
                background: widget.data.image != ''
                    ? Image.network(
                        widget.data.image ?? "",
                        fit: BoxFit.cover,
                      )
                    : Container(),
              ),
            )
          ];
        },
        body: PagedListView<int, MSong>.separated(
          pagingController: _pageController,
          builderDelegate: PagedChildBuilderDelegate(
            itemBuilder: (context, item, index) {
              return ListTile(
                leading: const CircleAvatar(
                  child: Icon(LineIcons.music),
                ),
                title: Text(item.title ?? ""),
                subtitle: Text(item.artist ?? ""),
                onTap: () => context.push("/lyric/${item.uid}"),
              );
            },
          ),
          separatorBuilder: (context, index) => const Divider(height: 0.0),
        ),
      ),
    );
  }
}
