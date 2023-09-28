import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recparenting/src/forum/bloc/forum_thread_bloc.dart';
import 'package:recparenting/src/forum/models/thread.model.dart';
import 'package:recparenting/src/forum/ui/widgets/thread_create_message_form.widget.dart';

class ThreadActionButton extends StatelessWidget {
  final ThreadForum thread;
  const ThreadActionButton({required this.thread, super.key});

  @override
  Widget build(BuildContext context) => IconButton(
      onPressed: () => showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext ctx) => BlocProvider.value(
              value: BlocProvider.of<ForumThreadBloc>(context),
              child: ThreadCreateMessageForm(threadId: thread.id))),
      icon: const Icon(Icons.add_circle_outline));
}
