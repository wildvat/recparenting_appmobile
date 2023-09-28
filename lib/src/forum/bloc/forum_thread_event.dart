part of 'forum_thread_bloc.dart';

sealed class ForumThreadEvent extends Equatable {
  const ForumThreadEvent();

  @override
  List<Object> get props => [];
}

class ForumThreadFetch extends ForumThreadEvent {
  final int page;
  final String? search;
  const ForumThreadFetch({required this.page, this.search});
}

class ForumMessageCreated extends ForumThreadEvent {
  final MessageForum message;
  const ForumMessageCreated({required this.message});
}

class ForumMessageRemove extends ForumThreadEvent {
  final String id;
  const ForumMessageRemove({required this.id});
}
