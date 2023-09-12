part of 'current_user_bloc.dart';

@immutable
abstract class CurrentUserState extends Equatable {
  const CurrentUserState();
  @override
  List<Object> get props => [];
}
class CurrentUserUninitialized extends CurrentUserState {
  const CurrentUserUninitialized();
}

class CurrentUserLoaded extends CurrentUserState {
  final User user;
  const CurrentUserLoaded(this.user);
  @override
  List<Object> get props => [user];
}
