import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'forum_thread_event.dart';
part 'forum_thread_state.dart';

class ForumThreadBloc extends Bloc<ForumThreadEvent, ForumThreadState> {
  ForumThreadBloc() : super(ForumThreadInitial()) {
    on<ForumThreadEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
