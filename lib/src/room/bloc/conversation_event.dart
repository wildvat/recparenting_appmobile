part of 'conversation_bloc.dart';

sealed class ConversationEvent extends Equatable {
  const ConversationEvent();

  @override
  List<Object> get props => [];
}

class AddMessageToConversation extends ConversationEvent {
  final Message message;
  const AddMessageToConversation({required this.message});
}
class ReceiveMessageToConversation extends ConversationEvent {
  final Message message;
  const ReceiveMessageToConversation({required this.message});
}
class ConversationFetch extends ConversationEvent {
  final int? page;
  const ConversationFetch({required this.page});
}
