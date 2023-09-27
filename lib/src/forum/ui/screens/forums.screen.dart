import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:recparenting/_shared/models/bloc_status.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/models/text_sizes.enum.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:recparenting/_shared/ui/widgets/search_input.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:recparenting/routes.dart';
import 'package:recparenting/src/forum/bloc/forum_bloc.dart';

class ForumsScreen extends StatefulWidget {
  const ForumsScreen({super.key});

  @override
  State<ForumsScreen> createState() => _ForumsScreenState();
}

class _ForumsScreenState extends State<ForumsScreen>
    with TickerProviderStateMixin {
  late final ForumBloc _forumBloc;
  final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
  final int maxCharacters = 75;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _forumBloc = ForumBloc()..add(const ForumThreadsFetch(page: 1));
    _scrollController = ScrollController();
    _scrollController.addListener(_onListener);
  }

  void _onListener() {
    //print(_scrollController.position.extentAfter);
    if (_scrollController.position.extentAfter < 200 &&
        !_forumBloc.state.hasReachedMax &&
        _forumBloc.state.blocStatus == BlocStatus.loaded) {
      print('fecth!!');
      _forumBloc.add(ForumThreadsFetch(page: _forumBloc.state.page + 1));
    }
  }

  void _onFieldSubmitted(value) {
    _forumBloc.add(ForumThreadsFetch(page: 1, search: '$value'));
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
        tabBar: TabBar(
          indicatorColor: colorRecDark,
          dividerColor: Colors.transparent,
          indicator: const BoxDecoration(),
          padding: const EdgeInsets.only(bottom: 10),
          controller: TabController(length: 1, vsync: this),
          tabs: [
            Tab(
              child: SearchInputForm(
                onFieldSubmitted: _onFieldSubmitted,
              ),
            )
          ],
        ),
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
                        builder: (context, scrollController) =>
                            ListView.builder(
                                controller: scrollController,
                                itemCount: 200,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        Text('$index')));
                  });
            },
            icon: const Icon(Icons.add_circle_outline)),
        title: AppLocalizations.of(context)!.menuForum,
        body: BlocProvider(
          create: (context) => _forumBloc,
          child: BlocBuilder<ForumBloc, ForumState>(
            builder: (context, state) {
              return Stack(
                children: [
                  ListView.builder(
                    controller: _scrollController,
                    itemCount: state.threads.length,
                    itemBuilder: (context, index) {
                      String? prevMessage;
                      if (state.threads[index]!.lastMessage != null) {
                        prevMessage = Bidi.stripHtmlIfNeeded(
                            state.threads[index]!.lastMessage!.message);
                        prevMessage =
                            '${prevMessage.substring(0, prevMessage.length > maxCharacters ? maxCharacters : prevMessage.length)}...';
                      }
                      return ListTile(
                        onTap: () => RouterRec.goToThread(
                            context, state.threads[index]!),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15),
                        tileColor: index % 2 == 0
                            ? Colors.white
                            : Colors.grey.shade200,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextDefault(
                              state.threads[index]!.title,
                              color: TextColors.rec,
                            ),
                            const SizedBox(height: 10),
                            prevMessage != null
                                ? TextDefault(
                                    prevMessage,
                                    color: TextColors.dark,
                                    size: TextSizes.small,
                                  )
                                : const SizedBox.shrink(),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextDefault(
                                  state.threads[index]!.lastMessage != null
                                      ? formatter.format(state.threads[index]!
                                          .lastMessage!.createdAt
                                          .toLocal())
                                      : formatter.format(state
                                          .threads[index]!.createdAt
                                          .toLocal()),
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
                                    TextDefault(
                                        state.threads[index]!.totalMessages
                                            .toString(),
                                        color: TextColors.rec,
                                        size: TextSizes.small)
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  state.blocStatus == BlocStatus.loading
                      ? const Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        )
                      : const SizedBox.shrink()
                ],
              );
            },
          ),
        ));
  }
}
