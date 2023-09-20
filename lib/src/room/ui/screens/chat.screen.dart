import 'package:flutter/material.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/room/providers/pusher.provider.dart';

class ChatScreen extends StatefulWidget {
  final Patient patient;
  const ChatScreen({required this.patient, super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatApi _chatApi = ChatApi();

  @override
  void initState() {
    super.initState();
    _chatApi.connect(widget.patient.room);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
      body: Text(widget.patient.room),
    );
  }
}
