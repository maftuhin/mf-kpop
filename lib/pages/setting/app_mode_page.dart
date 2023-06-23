import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModePage extends StatefulWidget {
  const AppModePage({super.key});

  @override
  State<AppModePage> createState() => _AppModePageState();
}

class _AppModePageState extends State<AppModePage> {
  var isOnline = true;

  @override
  void initState() {
    fetchAppMode();
    super.initState();
  }

  Future fetchAppMode() async {
    final prefs = await SharedPreferences.getInstance();
    final appMode = prefs.getBool("app_mode") ?? true;
    setState(() {
      isOnline = appMode;
    });
  }

  Future changeMode(bool value) async {
    setState(() {
      isOnline = value;
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("app_mode", value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Mode"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isOnline
                  ? FluentIcons.wifi_1_20_regular
                  : FluentIcons.wifi_off_20_regular,
              size: 100,
              color: isOnline ? Colors.green : Colors.red,
            ),
            Switch(value: isOnline, onChanged: changeMode),
            const Divider(),
            Text(
              isOnline
                  ? "This application will show data from server, switch to offline mode to get data from downloaded lyrics\n"
                  : "This application will show data from downloaded lyrics only, switch to online to get data from server",
              maxLines: 2,
            )
          ],
        ),
      ),
    );
  }
}
