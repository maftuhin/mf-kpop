import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kpop_lyrics/models/m_artist.dart';
import 'package:kpop_lyrics/models/m_track.dart';
import 'package:kpop_lyrics/pages/artist/artist_page.dart';
import 'package:kpop_lyrics/pages/bookmark/bookmark_page.dart';
import 'package:kpop_lyrics/pages/community/community_page.dart';
import 'package:kpop_lyrics/pages/community/profile_page.dart';
import 'package:kpop_lyrics/pages/home/home.dart';
import 'package:kpop_lyrics/pages/leaderboard/most_viewed_page.dart';
import 'package:kpop_lyrics/pages/lyric/lyric_page.dart';
import 'package:kpop_lyrics/pages/notification/notification_page.dart';
import 'package:kpop_lyrics/pages/request/request_page.dart';
import 'package:kpop_lyrics/pages/search/search_artist_page.dart';
import 'package:kpop_lyrics/pages/search/search_lyric_page.dart';
import 'package:kpop_lyrics/pages/soundtrack/soundtrack_page.dart';
import 'package:kpop_lyrics/pages/timeline/timeline_page.dart';

import '../pages/search/search_sountrack_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: "/",
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      routes: [
        GoRoute(
          path: "/",
          pageBuilder: (context, state) => const NoTransitionPage(
            child: TimelinePage(),
          ),
        ),
        GoRoute(
          path: "/search/artist",
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SearchArtistPage(),
          ),
        ),
        GoRoute(
          path: "/search/lyric",
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SearchLyricPage(),
          ),
        ),
        GoRoute(
          path: "/search/soundtrack",
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SearchSoundtrackPage(),
          ),
        ),
        GoRoute(
          path: "/bookmark",
          pageBuilder: (context, state) => const NoTransitionPage(
            child: BookmarkPage(),
          ),
        ),
      ],
      builder: (context, state, child) => HomePage(child: child),
    ),
    GoRoute(
      path: "/artist/:code",
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final artist = state.extra as MArtist;
        return ArtistPage(artist: artist);
      },
    ),
    GoRoute(
      path: "/lyric/:uid",
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final uid = state.pathParameters["uid"];
        return LyricPage(uid);
      },
    ),
    GoRoute(
      path: "/request",
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RequestPage(),
    ),
    GoRoute(
      path: "/notification",
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const NotificationPage(),
    ),
    GoRoute(
      path: "/most-viewed",
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const MostViewedPage(),
    ),
    GoRoute(
      path: "/community/:code",
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final artist = state.extra as MArtist;
        return CommunityPage(
          artist: artist,
        );
      },
    ),
    GoRoute(
      path: "/soundtrack/:uid",
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final track = state.extra as MTrack;
        return SoundtrackPage(data: track);
      },
    ),
    GoRoute(
      path: "/profile",
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ProfilePage(),
    ),
  ],
);
