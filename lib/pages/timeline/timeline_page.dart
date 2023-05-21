import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:kpop_lyrics/pages/timeline/ads_section.dart';
import 'package:kpop_lyrics/pages/timeline/last_update_section.dart';
import 'package:kpop_lyrics/pages/timeline/menu_section.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({super.key});

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  @override
  void initState() {
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      var link = event.data["link"];
      context.push(link);
    });
    super.initState();
  }

  Future<void> saveToBox(RemoteMessage event) async {
    final box = Hive.box("notifications");
    box.put(event.messageId, event.notification?.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdsSection(),
          MenuSection(),
          LastUpdateSection(),
        ],
      ),
    );
  }
}
