part of 'conference_bloc.dart';

@immutable
abstract class ConferenceState extends Equatable {
  const ConferenceState();
  @override
  List<Object> get props => [];
}
class ConferenceUninitialized extends ConferenceState {
  const ConferenceUninitialized();
}

class ConferenceLoaded extends ConferenceState {
  final Room room;
  const ConferenceLoaded(this.room);
  @override
  List<Object> get props => [room];
}
