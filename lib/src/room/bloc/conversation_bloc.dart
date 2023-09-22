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

  _onAddMessageToConversation(
      AddMessageToConversation event, Emitter<ConversationState> emit) async {
    print('*******************************************');
    print('entro en _onReceiveMessageToConversation ');
    try {
      final Message? message =
          await _addMessageToConversation(event.message);
      if (message == null) {
        print('no ahy mensajes');
        return;
      }
    } catch (_) {
      print('*******************************************');
      print('entro en  error _onAddMessageToConversation ');
      print(_.toString());
      emit(ConversationError());
    }
  }

  _onReceiveMessageToConversation(
      ReceiveMessageToConversation event, Emitter<ConversationState> emit) {
    print('*******************************************');
    print('entro en _onReceiveMessageToConversation ');
    print('Recibo un mensaje con event $event');
    try {
      if (state is ConversationLoaded) {
        print('emito el estado con copy with en ReceiveMessageToConversation');
        ConversationLoaded currentStatus = (state as ConversationLoaded);
        print('antes tenia ${currentStatus.messages.messages.length} mensajes');
        currentStatus.messages.messages.add(event.message);
        print(
            'y ahora tengo ${currentStatus.messages.messages.length} mensajes');
        // currentStatus.messages.total++;
        emit(ConversationLoading());

        emit((currentStatus).copyWith(messages: currentStatus.messages));

        print('finalizo el emit de _onReceiveMessageToConversation ');

        /*emit(ConversationLoaded(
            messages: currentStatus.messages,
            page: event.page ?? 1,
            hasReachedMax: false));*/
      } else {
        print('esta estate es ${state.runtimeType}');
      }
    }catch(_){
      print('*******************************************');
      print('entro en  error _onReceiveMessageToConversation ');
      print(_.toString());
      emit(ConversationError());
    }
  }

  _onFetchConversation(
    ConversationFetch event,
    Emitter<ConversationState> emit,
  ) async {
    try {
      print('*******************************************');
      print('entro en _onFetchConversation ');
      final Conversation? conversation =
          await _getConversation(event.page ?? 1);
      if (conversation == null) {
        emit(ConversationError());
        return;
      }
      if (state is ConversationLoaded) {
        print('emito el estado con copy with');
        ConversationLoaded currentStatus = (state as ConversationLoaded);
        //  currentStatus.messages.messages.addAll(conversation.messages.messages);
        emit(ConversationLoading());
        emit(currentStatus.copyWith(messages: conversation.messages));
        /*emit(ConversationLoaded(
            messages: conversation.messages,
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
      print(_.toString());
      emit(ConversationError());
    }
  }

  Future<Conversation?> _getConversation(int page) async {
    final RoomApi roomApi = RoomApi();
    print('entro a buscar nuevas conversaonces');
    return await roomApi.getConversation(roomId, page);
  }
  Future<Message?> _addMessageToConversation(Message message) async {
    final RoomApi roomApi = RoomApi();
    print('entro a crear nuevo menssage');
    return await roomApi.sendMessage(roomId, message);
  }
}
