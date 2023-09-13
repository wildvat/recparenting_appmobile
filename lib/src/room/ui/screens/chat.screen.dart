import 'package:flutter/material.dart';
import 'package:recparenting/_shared/ui/scaffold_default.dart';
import 'package:recparenting/src/room/providers/pusher.provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatApi _chatApi = ChatApi();

  @override
  void initState() {
    super.initState();
    _chatApi.connect();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
      body: const Text('chat'),
    );
  }
}
