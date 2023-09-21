import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:recparenting/src/room/models/message.model.dart';
import 'package:recparenting/src/room/models/messages.model.dart';

import '../models/conversation.model.dart';
import '../providers/room.provider.dart';

part 'conversation_state.dart';

part 'conversation_event.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final String roomId;

  ConversationBloc({required this.roomId})
      : super(ConversationUninitialized()) {
    on<ConversationFetch>(_onFetchConversation);
    on<AddMessageToConversation>(_onAddMessageToConversation);
    on<ReceiveMessageToConversation>(_onReceiveMessageToConversation);
  }

  _onAddMessageToConversation(AddMessageToConversation event, Emitter<ConversationState> state) {

    if (state is ConversationLoaded) {
      print('emito el estado con copy with');
      ConversationLoaded currentStatus = (state as ConversationLoaded);
      currentStatus.messages.messages.add(event.message);
      currentStatus.messages.total++;
      emit((state as ConversationLoaded).copyWith(messages: currentStatus.messages));
      /*emit(ConversationLoaded(
            messages: currentStatus.messages,
            page: event.page ?? 1,
            hasReachedMax: false));*/
    }
  }
  _onReceiveMessageToConversation(ReceiveMessageToConversation event, Emitter<ConversationState> state) {

    if (state is ConversationLoaded) {
      print('emito el estado con copy with');
      ConversationLoaded currentStatus = (state as ConversationLoaded);
      currentStatus.messages.messages.add(event.message);
      currentStatus.messages.total++;
      emit((state as ConversationLoaded).copyWith(messages: currentStatus.messages));
      /*emit(ConversationLoaded(
            messages: currentStatus.messages,
            page: event.page ?? 1,
            hasReachedMax: false));*/
    }
  }

  _onFetchConversation(
    ConversationFetch event,
    Emitter<ConversationState> emit,
  ) async {
    try {
      final Conversation? conversation =
          await _getConversation(event.page ?? 1);
      if (conversation == null) {
        emit(ConversationError());
        return;
      }
      if (state is ConversationLoaded) {
        print('emito el estado con copy with');
        ConversationLoaded currentStatus = (state as ConversationLoaded);
        currentStatus.messages.messages.addAll(conversation.messages.messages);
        emit((state as ConversationLoaded).copyWith(messages: currentStatus.messages));
        /*emit(ConversationLoaded(
            messages: currentStatus.messages,
            page: event.page ?? 1,
            hasReachedMax: false));*/
      } else {
        print('emito el estado suin copy with');

        emit(ConversationLoaded(
            messages: conversation.messages,
            page: event.page ?? 1,
            hasReachedMax: false));
      }
    } catch (_) {
      emit(ConversationError());
    }
  }

  Future<Conversation?> _getConversation(int page) async {
    final RoomApi roomApi = RoomApi();
    print('entro a buscar nuevas conversaonces');
    return await roomApi.getConversation(roomId, page);
  }
}

