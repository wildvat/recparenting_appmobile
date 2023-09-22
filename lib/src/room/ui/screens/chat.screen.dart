import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/room/bloc/conversation_bloc.dart';
import 'package:recparenting/src/room/ui/widgets/chat.widget.dart';

import '../../../../_shared/ui/widgets/app_submenu.widget.dart';

class ChatScreen extends StatefulWidget {
  final Patient patient;

  const ChatScreen({required this.patient, super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text( 'Conferecen with ${widget.patient.name}' ),
          actions: const [
            AppSubmenuWidget()
          ],
        ),

        body: BlocProvider(
            create: (_) => ConversationBloc(roomId: widget.patient.room),
            child: ChatWidget(patient: widget.patient)));
  }
}
