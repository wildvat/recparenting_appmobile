import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:recparenting/_shared/models/bloc_status.dart';
import 'package:recparenting/src/forum/models/message.forum.dart';
import 'package:recparenting/src/forum/models/thread_forum_list.model.dart';
import 'package:recparenting/src/forum/providers/forum.provider.dart';

part 'forum_thread_event.dart';
part 'forum_thread_state.dart';

class ForumThreadBloc extends Bloc<ForumThreadEvent, ForumThreadState> {
  final String threadId;

  ForumThreadBloc(this.threadId)
      : super(ForumThreadLoaded(
            blocStatus: BlocStatus.loaded, messages: const [], total: 0)) {
    on<ForumMessageCreated>(_onMesasgeCreated);
    on<ForumThreadMessagesFetch>(_onMessagesFecth);
    on<ForumMessageRemoved>(_onMesasgeRemoved);
  }

  void _onMessagesFecth(ForumThreadMessagesFetch event, Emitter emit) async {
    emit((state as ForumThreadLoaded).copyWith(
        messages: event.page > 1 ? state.messages : [],
        blocStatus: BlocStatus.loading));
    final ThreadForumList threadForumList =
        await ForumApi().getMessagesFromThread(
      threadId: threadId,
      page: event.page,
      search: event.search ?? '',
    );
    emit((state as ForumThreadLoaded).copyWith(
      messages: [...state.messages, ...threadForumList.messages],
      total: threadForumList.total,
      page: event.page,
      hasReachedMax: threadForumList.messages.length < 10,
      blocStatus: BlocStatus.loaded,
    ));
  }

  void _onMesasgeCreated(ForumMessageCreated event, Emitter emit) {
    emit((state as ForumThreadLoaded).copyWith(
        messages: [event.message, ...state.messages],
        total: state.total + 1,
        blocStatus: BlocStatus.loaded));
  }

  void _onMesasgeRemoved(ForumMessageRemoved event, Emitter emit) async {
    bool response = await ForumApi().deleteMessage(threadId, event.id);
    if (response) {
      emit((state as ForumThreadLoaded).copyWith(
          messages: state.messages.isNotEmpty
              ? state.messages
                  .where((element) => element!.id != event.id)
                  .toList(growable: false)
              : state.messages,
          total: state.total - 1,
          blocStatus: BlocStatus.loaded));
    }
  }
}
