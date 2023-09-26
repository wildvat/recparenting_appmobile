part of 'forum_thread_bloc.dart';

sealed class ForumThreadState extends Equatable {
  const ForumThreadState();
  
  @override
  List<Object> get props => [];
}

final class ForumThreadInitial extends ForumThreadState {}
