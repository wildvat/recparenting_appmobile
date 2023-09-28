import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recparenting/_shared/ui/widgets/search_input.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/src/forum/bloc/forum_bloc.dart';
import 'package:recparenting/src/forum/bloc/forum_thread_bloc.dart';
import 'package:recparenting/src/forum/models/forum_tabbar_type.enum.dart';

class ForumsTabbar extends StatefulWidget implements PreferredSizeWidget {
  final ForumTabbarType type;
  const ForumsTabbar({this.type = ForumTabbarType.forum, super.key});

  @override
  State<ForumsTabbar> createState() => _ForumsTabbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ForumsTabbarState extends State<ForumsTabbar>
    with TickerProviderStateMixin {
  void _onFieldSubmitted(value) {
    if (widget.type == ForumTabbarType.forum) {
      context
          .read<ForumBloc>()
          .add(ForumThreadsFetch(page: 1, search: '$value'));
    } else {
      context
          .read<ForumThreadBloc>()
          .add(ForumThreadMessagesFetch(page: 1, search: '$value'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
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
    );
  }
}
