import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:recparenting/_shared/models/bloc_status.dart';
import 'package:recparenting/src/forum/models/forum.list.model.dart';
import 'package:recparenting/src/forum/models/thread.model.dart';
import 'package:recparenting/src/forum/providers/forum.provider.dart';

part 'forum_event.dart';
part 'forum_state.dart';

class ForumBloc extends Bloc<ForumEvent, ForumState> {
  ForumBloc()
      : super(ForumLoaded(
          blocStatus: BlocStatus.loaded,
          threads: const [],
          total: 0,
        )) {
    on<ForumThreadsFetch>(_onForumThreadsFetch);
    on<ForumThreadCreated>(_onForumThreadsCreated);
  }

  void _onForumThreadsFetch(
      ForumThreadsFetch event, Emitter<ForumState> emit) async {
    emit((state as ForumLoaded).copyWith(
        threads: event.page > 1 ? state.threads : [],
        blocStatus: BlocStatus.loading));
    final ForumList forumListApi = await ForumApi()
        .getThreads(page: event.page, search: event.search ?? '');

    emit((state as ForumLoaded).copyWith(
      blocStatus: BlocStatus.loaded,
      search: event.search ?? '',
      page: event.page,
      threads: [...state.threads, ...forumListApi.threads],
      hasReachedMax: forumListApi.threads.length < 10,
      total: forumListApi.total,
    ));
  }

  void _onForumThreadsCreated(
      ForumThreadCreated event, Emitter<ForumState> emit) async {
    emit((state as ForumLoaded).copyWith(threads: [
      ...[event.thread],
      ...state.threads
    ], total: state.total + 1));
  }
}
