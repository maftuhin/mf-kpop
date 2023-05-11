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
          NavigationDestination(icon: Icon(LineIcons.home), label: "home"),
          NavigationDestination(icon: Icon(LineIcons.user), label: "artist"),
          NavigationDestination(icon: Icon(LineIcons.music), label: "lyric"),
          NavigationDestination(
            icon: Icon(LineIcons.listUl),
            label: "soundtrack",
          ),
          NavigationDestination(
            icon: Icon(LineIcons.bookmark),
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
