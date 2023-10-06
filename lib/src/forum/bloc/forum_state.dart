part of 'forum_bloc.dart';

sealed class ForumState extends Equatable {
  List<ThreadForum?> threads = [];
  int total = 0;
  BlocStatus blocStatus = BlocStatus.loading;
  int page = 1;
  bool hasReachedMax = false;
  String search = '';
}

final class ForumLoaded extends ForumState {
  List<ThreadForum?> threads;
  int total;
  BlocStatus blocStatus;
  int page;
  bool hasReachedMax;
  String search;

  ForumLoaded({
    required this.threads,
    required this.total,
    this.blocStatus = BlocStatus.loading,
    this.page = 1,
    this.search = '',
    this.hasReachedMax = false,
  });

  ForumLoaded copyWith({
    List<ThreadForum?>? threads,
    int? total,
    BlocStatus? blocStatus,
    int? page,
    String? search,
    bool? hasReachedMax,
  }) =>
      ForumLoaded(
        threads: threads ?? this.threads,
        total: total ?? this.total,
        page: page ?? this.page,
        search: search ?? this.search,
        blocStatus: blocStatus ?? this.blocStatus,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      );

  @override
  List<Object?> get props => [threads, total, blocStatus, page, hasReachedMax];
}
