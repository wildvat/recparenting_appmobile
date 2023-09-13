import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recparenting/_shared/ui/scaffold_default.dart';
import 'package:recparenting/src/current_user/bloc/current_user_bloc.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/room/providers/pusher.provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatApi _chatApi = ChatApi();
  late CurrentUserBloc _currentUserBloc;
  late Patient _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUserBloc = context.read<CurrentUserBloc>();
    _currentUser =
        (_currentUserBloc.state as CurrentUserLoaded).user as Patient;
    _chatApi.connect(_currentUser.room);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
      body: Text(_currentUser.room),
    );
  }
}
