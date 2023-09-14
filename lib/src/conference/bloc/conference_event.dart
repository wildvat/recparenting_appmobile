part of 'conference_bloc.dart';

@immutable
abstract class ConferenceEvent extends Equatable {
  const ConferenceEvent();

  @override
  List<Object> get props => [];
}
class ConferenceInitialize extends ConferenceEvent {}

class ConferenceUpdate extends ConferenceEvent {
  final Room room;
  const ConferenceUpdate(this.room);

  @override
  List<Object> get props => [room];
}
class JoinConference extends ConferenceEvent {
  final Room room;
  const JoinConference(this.room);

  @override
  List<Object> get props => [room];

  @override
  String toString() => 'FetchConference { filter: $room }';
}