import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:recparenting/src/forum/models/message.forum.dart';

part 'forum_thread_event.dart';
part 'forum_thread_state.dart';

class ForumThreadBloc extends Bloc<ForumThreadEvent, ForumThreadState> {
  ForumThreadBloc() : super(ForumThreadInitial()) {
    on<ForumMessageCreated>(_onMesasgeCreated);
    on<ForumThreadFetch>(_onMessagesFecth);
  }

  void _onMessagesFecth(ForumThreadFetch event, Emitter emit) {
    emit(state);
  }

  void _onMesasgeCreated(ForumMessageCreated event, Emitter emit) {
    emit(state);
  }
}
