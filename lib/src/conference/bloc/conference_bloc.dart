import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:recparenting/src/room/models/room.model.dart';

import '../../../_shared/helpers/push_permision.dart';

part 'conference_event.dart';
part 'conference_state.dart';

class ConferenceBloc extends Bloc<ConferenceEvent, ConferenceState> {
  ConferenceBloc() : super(const ConferenceUninitialized()) {
    on<JoinConference>(_onJoinConference);
    on<ConferenceInitialize>(_onCurrentUserInitialize);
  }

  _onCurrentUserInitialize(
      ConferenceInitialize event,
    Emitter<ConferenceState> emit,
  ) async {
    emit(const ConferenceUninitialized());
  }

  _onJoinConference(
      JoinConference event,
    Emitter<ConferenceState> emit,
  ) async {
    emit(ConferenceLoaded(event.room));
    getPermissionPushApp();
  }

getConference(Room room) {
  //ConferenceApi().joinConference(room);
  }
}
