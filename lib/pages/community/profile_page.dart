import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController uid = TextEditingController();
  TextEditingController firstName = TextEditingController();

  @override
  void initState() {
    _profileFromPreferences();
    super.initState();
  }

  Future<void> _profileFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid.text = prefs.getString("uid") ?? "";
    firstName.text = prefs.getString("firstName") ?? "";
  }

  Future<void> _saveProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("firstName", firstName.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CircleAvatar(radius: 40.0, child: Icon(FluentIcons.person_12_regular)),
            const SizedBox(height: 20.0),
            TextField(
              controller: uid,
              enabled: false,
              decoration: const InputDecoration(
                prefixIcon: Icon(FluentIcons.mail_16_regular),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: firstName,
              decoration: const InputDecoration(
                prefixIcon: Icon(FluentIcons.person_16_regular),
                border: OutlineInputBorder(),
                hintText: "Username"
              ),
            ),
            const SizedBox(height: 20.0),
            OutlinedButton(
              onPressed: () {
                _saveProfile();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Update Success"),
                    action: SnackBarAction(
                      label: "Close",
                      onPressed: () => context.pop(true),
                    ),
                  ),
                );
              },
              child: const Text("SAVE"),
            )
          ],
        ),
      ),
    );
  }
}
