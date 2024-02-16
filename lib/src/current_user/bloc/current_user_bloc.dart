import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:recparenting/_shared/models/user.model.dart';

part 'current_user_event.dart';

part 'current_user_state.dart';

class CurrentUserBloc extends Bloc<CurrentUserEvent, CurrentUserState> {
  CurrentUserBloc() :super(const CurrentUserUninitialized()) {
    on<FetchCurrentUser>(_onFetchUser);
    on<CurrentUserInitialize>(_onCurrentUserInitialize);
  }

  _onCurrentUserInitialize(CurrentUserInitialize event,
      Emitter<CurrentUserState> emit,) async {
    emit(const CurrentUserUninitialized());
  }

  _onFetchUser(FetchCurrentUser event,
      Emitter<CurrentUserState> emit,) async {
    emit(CurrentUserLoaded(event.user));
  }
}
