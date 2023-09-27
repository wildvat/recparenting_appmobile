import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/models/text_sizes.enum.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
import 'package:recparenting/routes.dart';
import 'package:recparenting/src/forum/models/thread.model.dart';

class ThreadCard extends StatefulWidget {
  int index;
  ThreadForum thread;
  String? prevMessage;
  ThreadCard(
      {required this.index, required this.thread, this.prevMessage, super.key});

  @override
  State<ThreadCard> createState() => _ThreadCardState();
}

class _ThreadCardState extends State<ThreadCard> {
  final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
  String? prevMessage;
  final int maxCharacters = 75;

  @override
  void initState() {
    super.initState();
    if (widget.thread.lastMessage != null) {
      prevMessage = Bidi.stripHtmlIfNeeded(widget.thread.lastMessage!.message);
      prevMessage =
          '${prevMessage!.substring(0, prevMessage!.length > maxCharacters ? maxCharacters : prevMessage!.length)}...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => RouterRec.goToThread(context, widget.thread),
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      tileColor: widget.index % 2 == 0 ? Colors.white : Colors.grey.shade200,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextDefault(
            widget.thread.title,
            color: TextColors.rec,
          ),
          const SizedBox(height: 10),
          widget.prevMessage != null
              ? TextDefault(
                  widget.prevMessage!,
                  color: TextColors.dark,
                  size: TextSizes.small,
                )
              : const SizedBox.shrink(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextDefault(
                widget.thread.lastMessage != null
                    ? formatter
                        .format(widget.thread.lastMessage!.createdAt.toLocal())
                    : formatter.format(widget.thread.createdAt.toLocal()),
                color: TextColors.muted,
                size: TextSizes.small,
              ),
              Row(
                children: [
                  Icon(
                    Icons.forum_outlined,
                    color: TextColors.rec.color,
                    size: 20,
                  ),
                  const SizedBox(width: 5),
                  TextDefault(widget.thread.totalMessages.toString(),
                      color: TextColors.rec, size: TextSizes.small)
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
