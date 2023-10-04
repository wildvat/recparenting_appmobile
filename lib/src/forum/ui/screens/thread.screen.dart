import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/src/forum/bloc/forum_thread_bloc.dart';
import 'package:recparenting/src/forum/models/thread.model.dart';
import 'package:recparenting/src/forum/ui/widgets/forum_thread_messages.widget.dart';
import 'package:recparenting/src/forum/ui/widgets/thread_action_button_widget.dart';

class ThreadScreen extends StatefulWidget {
  final ThreadForum thread;
  const ThreadScreen({required this.thread, super.key});

  @override
  State<ThreadScreen> createState() => _ThreadScreenState();
}

class _ThreadScreenState extends State<ThreadScreen> {
  late ForumThreadBloc _forumThreadBloc;

  @override
  void initState() {
    super.initState();
    _forumThreadBloc = ForumThreadBloc(widget.thread.id)
      ..add(const ForumThreadMessagesFetch(page: 1));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _forumThreadBloc,
        child: BlocBuilder<ForumThreadBloc, ForumThreadState>(
            builder: (BuildContext context, ForumThreadState state) =>
                ScaffoldDefault(
                    title: state.total > 0
                        ? AppLocalizations.of(context)!
                            .forumThreadTitle(state.total)
                        : '-',
                    actionButton: ThreadActionButton(thread: widget.thread),
                    body: ListView(
                      children: [
                        Container(
                            padding: const EdgeInsets.all(20),
                            color: colorRecDark,
                            child: TextDefault(widget.thread.title,
                                color: TextColors.white,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Padding(
                            padding: const EdgeInsets.all(20),
                            child: TextDefault(widget.thread.description)),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: FilledButton(
                              onPressed: state.total > 0
                                  ? () {
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (BuildContext cxt) {
                                            return DraggableScrollableSheet(
                                                expand: false,
                                                initialChildSize: 0.9,
                                                minChildSize: 0.2,
                                                maxChildSize: 0.9,
                                                builder: (cxtDraggable,
                                                        scrollController) =>
                                                    BlocProvider.value(
                                                      value: _forumThreadBloc,
                                                      child: ForumThreadMessagesWidget(
                                                          scrollController:
                                                              scrollController),
                                                    ));
                                          });
                                    }
                                  : null,
                              child: TextDefault(
                                AppLocalizations.of(context)!
                                    .forumThreadSeeMessagesBtn,
                                color: TextColors.white,
                              )),
                        )
                      ],
                    ))));
  }
}
