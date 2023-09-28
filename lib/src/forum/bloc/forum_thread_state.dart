part of 'forum_thread_bloc.dart';

sealed class ForumThreadState extends Equatable {
  List<MessageForum?> messages = [];
  int total = 0;
  BlocStatus blocStatus = BlocStatus.loading;
  int page = 1;
  bool hasReachedMax = false;
}

final class ForumThreadLoaded extends ForumThreadState {
  List<MessageForum?> messages;
  int total;
  BlocStatus blocStatus;
  int page;
  bool hasReachedMax;
  ForumThreadLoaded({
    required this.messages,
    required this.total,
    this.blocStatus = BlocStatus.loading,
    this.page = 1,
    this.hasReachedMax = false,
  });

  ForumThreadLoaded copyWith({
    List<MessageForum?>? messages,
    int? total,
    BlocStatus? blocStatus,
    int? page,
    bool? hasReachedMax,
  }) =>
      ForumThreadLoaded(
          messages: messages ?? this.messages,
          total: total ?? this.total,
          page: page ?? this.page,
          blocStatus: blocStatus ?? this.blocStatus,
          hasReachedMax: hasReachedMax ?? this.hasReachedMax);

  @override
  List<Object?> get props => [messages, total, blocStatus, page, hasReachedMax];
}
