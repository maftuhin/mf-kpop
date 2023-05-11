import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'package:kpop_lyrics/models/m_artist.dart';

class CommunityPage extends StatefulWidget {
  final MArtist artist;
  const CommunityPage({
    Key? key,
    required this.artist,
  }) : super(key: key);

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  late DatabaseReference refs;
  TextEditingController message = TextEditingController();
  StreamSubscription<DatabaseEvent>? _chatSubscription;

  var _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3a');
  final List<types.Message> _messages = [];

  @override
  void initState() {
    refs =
        FirebaseDatabase.instance.ref("chats").child(widget.artist.code ?? "");
    _generateUidWhenEmpty();
    listen();
    super.initState();
  }

  @override
  void dispose() {
    _chatSubscription?.cancel();
    super.dispose();
  }

  Future<void> _generateUidWhenEmpty() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString("uid") ?? "";
    if (uid.isEmpty) {
      await prefs.setString("uid", const Uuid().v4());
    }
    var role = types.Role.user;
    var firstName = prefs.getString("firstName") ?? "Anonymous";
    // Handle role and firstname
    if (firstName.contains("1806")) {
      role = types.Role.admin;
      firstName = firstName.replaceAll("1806", "");
    }
    _user = types.User(
      id: prefs.getString("uid") ?? "",
      role: role,
      firstName: firstName,
      imageUrl: prefs.getString("imageUrl"),
    );
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  Future<void> listen() async {
    _chatSubscription = refs.limitToLast(50).onChildAdded.listen((event) {
      try {
        Map<dynamic, dynamic> value = event.snapshot.value as Map;
        Map<String, dynamic> data =
            jsonDecode(jsonEncode(value)) as Map<String, dynamic>;
        final nm = types.Message.fromJson(data);
        setState(() {
          _messages.insert(0, nm);
        });
      } catch (e) {
        setState(() {
          _messages.clear();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("${widget.artist.name}"),
        actions: [
          IconButton(
            onPressed: () async {
              final bool? result = await context.push("/profile");
              if (result ?? false) {
                _generateUidWhenEmpty();
              }
            },
            icon: const Icon(LineIcons.userEdit),
          )
        ],
      ),
      body: Chat(
        messages: _messages,
        onAttachmentPressed: () => _pickFileAndUpload(),
        onPreviewDataFetched: _handlePreviewDataFetched,
        onSendPressed: (msg) => _send(msg.text),
        showUserNames: true,
        user: _user,
      ),
    );
  }

  Future<void> _pickFileAndUpload() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 700,
    );
    UploadTask? task = await uploadFile(file);
    task?.then((p0) async {
      final link = await p0.ref.getDownloadURL();
      final imageMessage = types.ImageMessage(
        name: file?.name ?? "",
        uri: link,
        size: 100,
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        showStatus: true,
      );
      await refs
          .push()
          .set(imageMessage.toJson())
          .then((value) {})
          .onError((error, stackTrace) {});
    });
  }

  Future<void> _send(String message) async {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message,
      showStatus: true,
    );

    await refs
        .push()
        .set(textMessage.toJson())
        .then((value) {})
        .onError((error, stackTrace) {});
  }

  Future<UploadTask?> uploadFile(XFile? file) async {
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No file was selected'),
        ),
      );
      return null;
    }

    UploadTask uploadTask;
    final now = DateTime.now();
    String dateString = DateFormat('y-M-d').format(now);
    // Create a Reference to the file
    Reference ref =
        FirebaseStorage.instance.ref().child(dateString).child(file.name);

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path},
    );
    uploadTask = ref.putFile(io.File(file.path), metadata);
    return Future.value(uploadTask);
  }
}
