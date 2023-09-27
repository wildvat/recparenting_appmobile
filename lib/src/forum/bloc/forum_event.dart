part of 'forum_bloc.dart';

sealed class ForumEvent extends Equatable {
  const ForumEvent();

  @override
  List<Object> get props => [];
}

class ForumThreadsFetch extends ForumEvent {
  final int page;
  final String? search;
  const ForumThreadsFetch({required this.page, this.search});
}

class ForumThreadCreated extends ForumEvent {
  final ThreadForum thread;
  const ForumThreadCreated({required this.thread});
}
