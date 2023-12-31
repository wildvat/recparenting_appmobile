import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/_shared/models/bloc_status.dart';
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
import 'package:recparenting/src/current_user/helpers/current_user_builder.dart';
import 'package:recparenting/src/forum/bloc/forum_bloc.dart';
import 'package:recparenting/src/forum/ui/widgets/forums_action_button.widget.dart';
import 'package:recparenting/src/forum/ui/widgets/forums_tabbar.widget.dart';
import 'package:recparenting/src/forum/ui/widgets/thread_card.widget.dart';

class ForumsScreen extends StatefulWidget {
  const ForumsScreen({super.key});

  @override
  State<ForumsScreen> createState() => _ForumsScreenState();
}

class _ForumsScreenState extends State<ForumsScreen> {
  late final ForumBloc _forumBloc;
  late final ScrollController _scrollController;
  late final User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = CurrentUserBuilder().value();
    _forumBloc = ForumBloc()..add(const ForumThreadsFetch(page: 1));
    _scrollController = ScrollController();
    _scrollController.addListener(_onListener);
  }

  void _onListener() {
    if (_scrollController.position.extentAfter < 200 &&
        !_forumBloc.state.hasReachedMax &&
        _forumBloc.state.blocStatus == BlocStatus.loaded) {
      _forumBloc.add(ForumThreadsFetch(
          page: _forumBloc.state.page + 1, search: _forumBloc.state.search));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _forumBloc,
        child: ScaffoldDefault(
          tabBar: const ForumsTabbar(),
          actionButton: const ForumsActionButton(),
          title: _currentUser.isPatient()
              ? AppLocalizations.of(context)!.menuCommunity
              : AppLocalizations.of(context)!.menuForum,
          body: BlocBuilder<ForumBloc, ForumState>(
            builder: (context, state) {
              if (state.hasReachedMax) {
                _scrollController.removeListener(_onListener);
              }
              return Stack(
                children: [
                  ListView.builder(
                      controller: _scrollController,
                      itemCount: state.threads.length,
                      itemBuilder: (context, index) => ThreadCard(
                          index: index, thread: state.threads[index]!)),
                  state.blocStatus == BlocStatus.loading
                      ? const Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        )
                      : const SizedBox.shrink(),
                  state.blocStatus == BlocStatus.loaded && state.threads.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(20),
                          child: TextDefault(
                              AppLocalizations.of(context)!.generalNoContent))
                      : const SizedBox.shrink()
                ],
              );
            },
          ),
        ));
  }
}
