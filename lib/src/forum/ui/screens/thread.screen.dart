import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/src/forum/models/thread.model.dart';

class ThreadScreen extends StatefulWidget {
  final ThreadForum thread;
  const ThreadScreen({required this.thread, super.key});

  @override
  State<ThreadScreen> createState() => _ThreadScreenState();
}

class _ThreadScreenState extends State<ThreadScreen> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
      title: AppLocalizations.of(context)!.forumThreadTitle,
      actionButton: IconButton(
          onPressed: () {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: 0.7,
                      minChildSize: 0.2,
                      maxChildSize: 0.7,
                      builder: (context, scrollController) => ListView.builder(
                          controller: scrollController,
                          itemCount: 200,
                          itemBuilder: (BuildContext context, int index) =>
                              Text('$index')));
                });
          },
          icon: const Icon(Icons.add_circle_outline)),
      body: ListView(
        children: [
          Container(
              padding: const EdgeInsets.all(20),
              color: colorRecDark,
              child: TextDefault(widget.thread.title,
                  color: TextColors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Padding(
              padding: const EdgeInsets.all(20),
              child: TextDefault(widget.thread.description)),
          Padding(
            padding: const EdgeInsets.all(20),
            child: FilledButton(
                onPressed: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return DraggableScrollableSheet(
                            expand: false,
                            initialChildSize: 0.9,
                            minChildSize: 0.2,
                            maxChildSize: 0.9,
                            builder: (context, scrollController) =>
                                ListView.builder(
                                    controller: scrollController,
                                    itemCount: 200,
                                    itemBuilder:
                                        (BuildContext context, int index) =>
                                            Text('$index')));
                      });
                },
                child: Text(
                    AppLocalizations.of(context)!.forumThreadSeeMessagesBtn)),
          )
        ],
      ),
    );
  }
}
