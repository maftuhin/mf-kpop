import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final indexProvider = StateProvider((ref) => 0);

class HomePage extends ConsumerWidget {
  final Widget child;
  const HomePage({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var index = ref.watch(indexProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("MF-KPOP APP"),
        actions: [
          IconButton(
            onPressed: () {
              context.push("/notification");
            },
            icon: const Icon(FluentIcons.alert_16_regular),
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
          var route = switch (value) {
            1 => "/search/artist",
            2 => "/search/lyric",
            3 => "/search/soundtrack",
            4 => "/bookmark",
            _ => "/",
          };
          context.go(route);
        },
      ),
    );
  }
}
