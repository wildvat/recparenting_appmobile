import 'package:bloc/bloc.dart';
import 'dart:developer' as developer;
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
    developer.log('*******************************************');
    developer.log('entro en _onReceiveMessageToConversation ');
    try {
      final Message? message = await _addMessageToConversation(event.message);
      if (message == null) {
        developer.log('no ahy mensajes');
        return;
      }
    } catch (error) {
      developer.log('*******************************************');
      developer.log('entro en  error _onAddMessageToConversation ');
      developer.log(error.toString());
      emit(ConversationError(error.toString()));
    }
  }

  _onReceiveMessageToConversation(
      ReceiveMessageToConversation event, Emitter<ConversationState> emit) {
    developer.log('*******************************************');
    developer.log('entro en _onReceiveMessageToConversation ');
    developer.log('Recibo un mensaje con event $event');
    try {
      if (state is ConversationLoaded) {
        developer.log(
            'emito el estado con copy with en ReceiveMessageToConversation');
        ConversationLoaded currentStatus = (state as ConversationLoaded);
        developer.log(
            'antes tenia ${currentStatus.messages.messages.length} mensajes');
        Messages messages = Messages(total: 1, messages: [event.message]);

        messages.messages.addAll(currentStatus.messages.messages);
        developer.log(
            'y ahora tengo ${currentStatus.messages.messages.length} mensajes');
        // currentStatus.messages.total++;
        emit(ConversationLoading());

        emit((currentStatus).copyWith(messages: messages));

        developer.log('finalizo el emit de _onReceiveMessageToConversation ');

        /*emit(ConversationLoaded(
            messages: currentStatus.messages,
            page: event.page ?? 1,
            hasReachedMax: false));*/
      } else {
        developer.log('esta estate es ${state.runtimeType}');
      }
    } catch (error) {
      developer.log('*******************************************');
      developer.log('entro en  error _onReceiveMessageToConversation ');
      developer.log(error.toString());
      emit(ConversationError(error.toString()));
    }
  }

  _onFetchConversation(
    ConversationFetch event,
    Emitter<ConversationState> emit,
  ) async {
    try {
      if (state is ConversationLoaded) {
        if ((state as ConversationLoaded).hasReachedMax) {
          return;
        }
        ConversationLoaded currentStatus = (state as ConversationLoaded);
        emit(ConversationLoading());
        emit(currentStatus.copyWith(loading: true));
      }

      final Conversation? conversation =
          await _getConversation(event.page ?? 1);
      if (conversation == null) {
        emit(const ConversationError('Error fetching conversation'));
        return;
      }

      if (state is ConversationLoaded) {
        ConversationLoaded currentStatus = (state as ConversationLoaded);
        emit(ConversationLoading());
        currentStatus.messages.messages.addAll(conversation.messages.messages);
        bool hasReachedMax = false;
        if (currentStatus.messages.messages.length ==
            currentStatus.messages.total) {
          hasReachedMax = true;
        }
        emit(currentStatus.copyWith(
            messages: currentStatus.messages,
            hasReachedMax: hasReachedMax,
            loading: false));
      } else {
        emit(ConversationLoaded(
            conversation: conversation,
            messages: conversation.messages,
            page: event.page ?? 1,
            hasReachedMax: false,
            indexDate: 0,
            loading: false));
      }
    } catch (error) {
      emit(ConversationError(error.toString()));
    }
  }

  _onDeleteMessageFromConversation(DeleteMessageFromConversation event,
      Emitter<ConversationState> emit) async {
    try {
      await _deleteMessageFromConversation(event.message);
      if (state is ConversationLoaded) {
        ConversationLoaded currentStatus = (state as ConversationLoaded);
        emit(ConversationLoading());
        int? message = currentStatus.messages.messages
            .indexWhere((element) => element.id == event.message.id);

        currentStatus.messages.messages[message] = event.message;
        emit(currentStatus.copyWith(messages: currentStatus.messages));
      }
    } catch (error) {
      developer.log(error.toString());
      emit(ConversationError(error.toString()));
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
