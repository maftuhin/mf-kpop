import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kpop_lyrics/core/mf_theme.dart';
import 'package:kpop_lyrics/firebase_options.dart';
import 'package:kpop_lyrics/routes/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp(
    name: "mf-kpop",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  await Hive.initFlutter();
  await Hive.openBox("bookmarks");
  await Hive.openBox("notifications");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: goRouter,
      title: 'Kpop App',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
    );
  }
}

Future<void> _messageHandler(RemoteMessage message) async {
  
}
