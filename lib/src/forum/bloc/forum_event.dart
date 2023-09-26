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

class ForumThreadCreate extends ForumEvent {
  final String title;
  final String description;
  const ForumThreadCreate({required this.title, required this.description});
}
