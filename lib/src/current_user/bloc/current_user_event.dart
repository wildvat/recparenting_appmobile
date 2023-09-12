part of 'current_user_bloc.dart';

@immutable
abstract class CurrentUserEvent extends Equatable {
  const CurrentUserEvent();

  @override
  List<Object> get props => [];
}
class CurrentUserInitialize extends CurrentUserEvent {}

class CurrentUserUpdate extends CurrentUserEvent {
  final User user;
  const CurrentUserUpdate(this.user);

  @override
  List<Object> get props => [user];
}
class FetchCurrentUser extends CurrentUserEvent {
  final User user;
  const FetchCurrentUser(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'FetchCurrentUser { filter: $user }';
}