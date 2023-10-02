import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recparenting/_shared/models/bloc_status.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/src/forum/bloc/forum_thread_bloc.dart';
import 'package:recparenting/src/forum/models/forum_tabbar_type.enum.dart';
import 'package:recparenting/src/forum/ui/widgets/forum_thread_message_card.widget.dart';
import 'package:recparenting/src/forum/ui/widgets/forums_tabbar.widget.dart';

class ForumThreadMessagesWidget extends StatefulWidget {
  final ScrollController scrollController;
  const ForumThreadMessagesWidget({required this.scrollController, super.key});

  @override
  State<ForumThreadMessagesWidget> createState() =>
      _ForumThreadMessagesWidgetState();
}

class _ForumThreadMessagesWidgetState extends State<ForumThreadMessagesWidget> {
  ForumThreadBloc get _forumBloc => context.read<ForumThreadBloc>();

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScrollListener);
  }

  _onScrollListener() {
    if (widget.scrollController.position.extentAfter < 200 &&
        !_forumBloc.state.hasReachedMax &&
        _forumBloc.state.blocStatus == BlocStatus.loaded) {
      _forumBloc.add(ForumThreadMessagesFetch(page: _forumBloc.state.page + 1));
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ForumThreadBloc, ForumThreadState>(
          builder: (BuildContext context, ForumThreadState state) => Stack(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      controller: widget.scrollController,
                      itemCount: state.messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < 1) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 10),
                                color: colorRecDark,
                                child: const ForumsTabbar(
                                  type: ForumTabbarType.thread,
                                ),
                              ),
                              ForumThreadMessageCardWidget(
                                index: index,
                                message: state.messages[index]!,
                              )
                            ],
                          );
                        }
                        return ForumThreadMessageCardWidget(
                          index: index,
                          message: state.messages[index]!,
                        );
                      }),
                  Positioned(
                      top: 5,
                      right: 5,
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: colorRecDark,
                        child: IconButton(
                          color: colorRec,
                          icon: const Icon(
                            Icons.arrow_circle_left_outlined,
                            color: Colors.white,
                            size: 34,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      )),
                  Center(
                      child: state.blocStatus == BlocStatus.loading
                          ? const CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            )
                          : const SizedBox.shrink())
                ],
              ));
}
