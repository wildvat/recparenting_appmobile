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
  final RoomApi roomApi = RoomApi();

  ConversationBloc({required this.roomId})
      : super(ConversationUninitialized()) {
    on<ConversationFetch>(_onFetchConversation);
    on<AddMessageToConversation>(_onAddMessageToConversation);
    on<ReceiveMessageToConversation>(_onReceiveMessageToConversation);
    on<DeleteMessageFromConversation>(_onDeleteMessageFromConversation);

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
        Messages messages = Messages(total: 1, messages: [event.message]);

        messages.messages.addAll(currentStatus.messages.messages);
        print(
            'y ahora tengo ${currentStatus.messages.messages.length} mensajes');
        // currentStatus.messages.total++;
        emit(ConversationLoading());

        emit((currentStatus).copyWith(messages: messages));

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

      if (state is ConversationLoaded) {
          if((state as ConversationLoaded).hasReachedMax){
            return;
          }
      }

      final Conversation? conversation =await _getConversation(event.page ?? 1);
      if (conversation == null) {
        emit(ConversationError());
        return;
      }

      if(conversation.messages.messages.isEmpty){
        return ;
      }

      if (state is ConversationLoaded) {
        ConversationLoaded currentStatus = (state as ConversationLoaded);
        emit(ConversationLoading());
        currentStatus.messages.messages.addAll(conversation.messages.messages);
        /*if(conversation.messages.messages.isNotEmpty){
          for(var message in conversation.messages.messages){
            messages.insert(0, message);
          }
        }*/
       // conversation.messages.messages.addAll(currentStatus.messages.messages);
        bool hasReachedMax = false;
        if(currentStatus.messages.messages.length == currentStatus.messages.total){
          hasReachedMax = true;
        }
        emit(currentStatus.copyWith(messages: currentStatus.messages, hasReachedMax: hasReachedMax));

      } else {
        emit(ConversationLoaded(
            messages: conversation.messages,
            page: event.page ?? 1,
            hasReachedMax: false));
      }
    } catch (_) {
      emit(ConversationError());
    }
  }
  _onDeleteMessageFromConversation(
      DeleteMessageFromConversation event, Emitter<ConversationState> emit) async {
    try {
      await _deleteMessageFromConversation(event.message);
      if (state is ConversationLoaded) {
        ConversationLoaded currentStatus = (state as ConversationLoaded);
        emit(ConversationLoading());
        int? message = currentStatus.messages.messages.indexWhere((element) => element!.id == event.message.id);

        if(message != null){
          currentStatus.messages.messages[message] = event.message;
        }
       emit(currentStatus.copyWith(messages: currentStatus.messages));
      }
    } catch (_) {
      print(_.toString());
      emit(ConversationError());
    }
  }

  Future<Conversation?> _getConversation(int page) async {
    return await roomApi.getConversation(roomId, page);
  }
  Future<Message?> _addMessageToConversation(Message message) async {
    return await roomApi.sendMessage(roomId, message);
  }
  Future<void> _deleteMessageFromConversation(Message message) async {
    return await roomApi.deleteMessage(roomId, message.id);
  }
}
