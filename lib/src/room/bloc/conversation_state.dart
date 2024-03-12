part of 'conversation_bloc.dart';

@immutable
abstract class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object> get props => [];
}

class ConversationUninitialized extends ConversationState {}

class ConversationError extends ConversationState {
  final String errorMessage;
  const ConversationError(this.errorMessage);
}

class ConversationLoading extends ConversationState {}

final class ConversationLoaded extends ConversationState {
  final Conversation conversation;
  final Messages messages;
  final int page;
  final bool hasReachedMax;
  final int indexDate;
  final bool loading;

  const ConversationLoaded({
    required this.conversation,
    required this.messages,
    required this.page,
    required this.hasReachedMax,
    required this.indexDate,
    this.loading = false,
  });

  ConversationLoaded copyWith({
    Conversation? conversation,
    Messages? messages,
    int? page,
    bool? hasReachedMax,
    int? indexDate,
    bool? loading,
  }) {
    return ConversationLoaded(
      conversation: conversation ?? this.conversation,
      messages: messages ?? this.messages,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      indexDate: indexDate ?? this.indexDate,
      loading: loading ?? this.loading,
    );
  }
}
