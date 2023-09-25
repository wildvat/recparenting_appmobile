
part of 'conversation_bloc.dart';


@immutable
abstract class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object> get props => [];
}


class ConversationUninitialized extends ConversationState {}
class ConversationError extends ConversationState {}
class ConversationLoading extends ConversationState {}

final class ConversationLoaded extends ConversationState {
  final Messages messages;
  final int page;
  final bool hasReachedMax;
  final int indexDate;
  final bool loading;

  const ConversationLoaded({
    required this.messages,
    required this.page,
    required this.hasReachedMax,
    required this.indexDate,
    this.loading = false,
  });

  ConversationLoaded copyWith({
    Messages? messages,
    int? page,
    bool? hasReachedMax,
    int? indexDate,
    bool? loading,
  }) {
    return ConversationLoaded(
      messages: messages ?? this.messages,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      indexDate: indexDate ?? this.indexDate,
      loading: loading ?? this.loading,
    );
  }
}
