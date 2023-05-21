import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:kpop_lyrics/models/m_artist.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final List<MArtist> data = [];

  @override
  void initState() {
    fetchNotification();
    super.initState();
  }

  void fetchNotification() {
    final box = Hive.box("notifications");
    for (var element in box.values) {
      var artist = MArtist();
      artist.name = element["name"];
      artist.code = element["code"];
      setState(() {
        data.add(artist);
      });
    }
  }

  Future<void> unsubscribeFromTopic(MArtist a) async {
    setState(() {
      data.remove(a);
    });
    var box = Hive.box("notifications");
    box.delete(a.code ?? "");
    await FirebaseMessaging.instance.unsubscribeFromTopic(a.code ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification"),
      ),
      body: data.isNotEmpty
          ? ListView.separated(
              itemBuilder: (context, index) {
                final item = data[index];
                return _NotificationItem(
                  item: item,
                  onChange: (d, status) async {
                    unsubscribeFromTopic(d);
                  },
                );
              },
              separatorBuilder: (context, index) => const Divider(height: 0.0),
              itemCount: data.length,
            )
          : const Center(
              child: Text("you are not subscribed to any notification update"),
            ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final MArtist item;
  final Function(MArtist data, bool status) onChange;
  const _NotificationItem({
    Key? key,
    required this.item,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name ?? ""),
      trailing: Switch(
        value: true,
        onChanged: (value) => onChange(item, value),
      ),
      onTap: () {},
    );
  }
}
