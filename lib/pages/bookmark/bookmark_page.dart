import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:kpop_lyrics/models/m_song.dart';
import 'package:line_icons/line_icons.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final List<MSong> data = [];
  @override
  void initState() {
    fetch();
    super.initState();
  }

  Future<void> fetch() async {
    var box = Hive.box("bookmarks");
    for (var element in box.values) {
      final song = MSong();
      song.artist = element["artist"] ?? "";
      song.uid = element["uid"] ?? "";
      song.title = element["title"] ?? "";
      setState(() {
        data.add(song);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(height: 0.0),
      itemBuilder: (context, index) {
        final item = data[index];
        return ListTile(
          leading: const CircleAvatar(
            child: Icon(LineIcons.music),
          ),
          trailing: IconButton(
            onPressed: () {
              var box = Hive.box("bookmarks");
              box.delete(item.uid);
              setState(() {
                data.clear();
              });
              fetch();
            },
            icon: const Icon(LineIcons.trash),
          ),
          title: Text(item.title ?? ""),
          onTap: () {
            context.push("/lyric/${item.uid}");
          },
        );
      },
      itemCount: data.length,
    );
  }
}
