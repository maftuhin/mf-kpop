import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:kpop_lyrics/models/m_notification.dart';
import 'package:line_icons/line_icons.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final List<MNotification> data = [];

  @override
  void initState() {
    fetchNotification();
    super.initState();
  }

  void fetchNotification() {
    final box = Hive.box("notifications");
    for (var element in box.values) {
      var notification = MNotification();
      notification.title = element["title"];
      notification.body = element["body"];
      setState(() {
        data.add(notification);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification"),
        actions: [
          IconButton(
              onPressed: () {
                var box = Hive.box("notifications");
                box.clear();
                setState(() => data.clear());
              },
              icon: const Icon(LineIcons.trash)),
        ],
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          final item = data[index];
          return _NotificationItem(item: item);
        },
        separatorBuilder: (context, index) => const Divider(height: 0.0),
        itemCount: data.length,
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final MNotification item;
  const _NotificationItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.title ?? ""),
      subtitle: Text(item.body ?? ""),
      dense: item.isRead,
      isThreeLine: true,
      onTap: () {},
    );
  }
}
