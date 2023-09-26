part of 'forum_bloc.dart';

sealed class ForumState extends Equatable {
  List<ThreadForum?> threads = [];
  int total = 0;
  BlocStatus blocStatus = BlocStatus.loading;
  int page = 1;
  bool hasReachedMax = false;
}

final class ForumLoaded extends ForumState {
  List<ThreadForum?> threads;
  int total;
  BlocStatus blocStatus;
  int page;
  bool hasReachedMax;

  ForumLoaded({
    required this.threads,
    required this.total,
    this.blocStatus = BlocStatus.loading,
    this.page = 1,
    this.hasReachedMax = false,
  });

  ForumLoaded copyWith({
    List<ThreadForum?>? threads,
    int? total,
    BlocStatus? blocStatus,
    int? page,
    bool? hasReachedMax,
  }) =>
      ForumLoaded(
        threads: threads ?? this.threads,
        total: total ?? this.total,
        page: page ?? this.page,
        blocStatus: blocStatus ?? this.blocStatus,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      );

  @override
  List<Object?> get props => [threads, total, blocStatus, page, hasReachedMax];
}
