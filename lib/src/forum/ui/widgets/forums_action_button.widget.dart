import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recparenting/src/forum/bloc/forum_bloc.dart';
import 'package:recparenting/src/forum/ui/widgets/forum_create_thread_form.widget.dart';

class ForumsActionButton extends StatefulWidget {
  const ForumsActionButton({super.key});

  @override
  State<ForumsActionButton> createState() => _ForumsActionButtonState();
}

class _ForumsActionButtonState extends State<ForumsActionButton> {
  @override
  Widget build(BuildContext context) => IconButton(
      onPressed: () => showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          useSafeArea: true,
          builder: (BuildContext ctx) => BlocProvider.value(
              value: BlocProvider.of<ForumBloc>(context),
              child: const ForumCreateThreadFrom())),
      icon: const Icon(Icons.add_circle_outline));
}
