import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';

final indexProvider = StateProvider((ref) => 0);

class HomePage extends ConsumerWidget {
  final Widget child;
  const HomePage({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var index = ref.watch(indexProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("KPOP APP"),
        actions: [
          IconButton(
            onPressed: () {
              context.push("/notification");
            },
            icon: const Icon(LineIcons.bell),
          ),
        ],
      ),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
              icon: Icon(FluentIcons.home_16_regular), label: "home"),
          NavigationDestination(
              icon: Icon(FluentIcons.person_16_regular), label: "artist"),
          NavigationDestination(
              icon: Icon(FluentIcons.music_note_2_16_regular), label: "lyric"),
          NavigationDestination(
            icon: Icon(FluentIcons.list_bar_16_regular),
            label: "soundtrack",
          ),
          NavigationDestination(
            icon: Icon(FluentIcons.bookmark_16_regular),
            label: "bookmark",
          ),
        ],
        onDestinationSelected: (value) {
          ref.read(indexProvider.notifier).state = value;
          var route = "";
          switch (value) {
            case 1:
              route = "/search/artist";
              break;
            case 2:
              route = "/search/lyric";
              break;
            case 3:
              route = "/search/soundtrack";
              break;
            case 4:
              route = "/bookmark";
              break;
            default:
              route = "/";
          }
          context.go(route);
        },
      ),
    );
  }
}
