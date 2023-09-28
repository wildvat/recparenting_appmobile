import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/_shared/helpers/avatar_image.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/models/text_sizes.enum.dart';
import 'package:recparenting/_shared/ui/widgets/show_files.widget.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/src/forum/bloc/forum_thread_bloc.dart';
import 'package:recparenting/src/forum/models/message.forum.dart';
import 'package:recparenting/src/forum/ui/widgets/thread_create_message_form.widget.dart';

class ForumThreadMessageCardWidget extends StatefulWidget {
  final int index;
  final MessageForum message;
  const ForumThreadMessageCardWidget(
      {required this.message, required this.index, super.key});

  @override
  State<ForumThreadMessageCardWidget> createState() =>
      _ForumThreadMessageCardWidgetState();
}

class _ForumThreadMessageCardWidgetState
    extends State<ForumThreadMessageCardWidget> {
  final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
  bool _expandReplyMessage = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.index % 2 == 0 ? Colors.white : Colors.grey.shade200,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: AvatarImage(user: widget.message.user),
                ),
              ),
              const SizedBox(width: 10),
              TextDefault(
                widget.message.user.name,
                color: TextColors.rec,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          widget.message.parent != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        iconColor: MaterialStateProperty.all(colorRec),
                      ),
                      label: TextDefault(
                        AppLocalizations.of(context)!
                            .forumThreadMessageCreateReplyLink(
                                widget.message.parent!.user.name),
                        color: TextColors.rec,
                        size: TextSizes.small,
                        fontWeight: FontWeight.normal,
                      ),
                      icon: const Icon(Icons.reply),
                      onPressed: () => setState(
                          () => _expandReplyMessage = !_expandReplyMessage),
                    ),
                    _expandReplyMessage
                        ? Column(
                            children: [
                              const SizedBox(height: 10),
                              TextDefault(
                                Bidi.stripHtmlIfNeeded(
                                    widget.message.parent!.message),
                                color: TextColors.rec,
                              )
                            ],
                          )
                        : const SizedBox.shrink(),
                  ],
                )
              : const SizedBox.shrink(),
          const SizedBox(height: 10),
          TextDefault(Bidi.stripHtmlIfNeeded(widget.message.message)),
          widget.message.files.isNotEmpty
              ? Column(
                  children: [
                    const SizedBox(height: 20),
                    ShowFilesWidget(
                      files: widget.message.files,
                    ),
                  ],
                )
              : const SizedBox.shrink(),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                label: Text(AppLocalizations.of(context)!.generalReplyBtn),
                onPressed: () => showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    useSafeArea: true,
                    builder: (BuildContext ctx) => BlocProvider.value(
                        value: BlocProvider.of<ForumThreadBloc>(context),
                        child: ThreadCreateMessageForm(
                            parentId: widget.message.id,
                            threadId: widget.message.forumId))),
                icon: const Icon(Icons.reply),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
                ),
              ),
              TextDefault(
                formatter.format(widget.message.createdAt),
                size: TextSizes.small,
                color: TextColors.muted,
              )
            ],
          )
        ],
      ),
    );
  }
}
