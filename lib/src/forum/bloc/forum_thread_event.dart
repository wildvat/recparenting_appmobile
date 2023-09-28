part of 'forum_thread_bloc.dart';

sealed class ForumThreadEvent extends Equatable {
  const ForumThreadEvent();

  @override
  List<Object> get props => [];
}

class ForumThreadMessagesFetch extends ForumThreadEvent {
  final int page;
  final String? search;
  const ForumThreadMessagesFetch({required this.page, this.search});
}

class ForumMessageCreated extends ForumThreadEvent {
  final MessageForum message;
  const ForumMessageCreated({required this.message});
}

class ForumMessageRemoved extends ForumThreadEvent {
  final String id;
  const ForumMessageRemoved({required this.id});
}
