import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:recparenting/_shared/models/bloc_status.dart';
import 'package:recparenting/src/room/models/room.model.dart';
import 'package:recparenting/src/room/models/rooms.model.dart';
import 'package:recparenting/src/room/providers/room.provider.dart';

part 'patients_event.dart';
part 'patients_state.dart';

class PatientsBloc extends Bloc<PatientsEvent, PatientsState> {
  PatientsBloc()
      : super(PatientsLoaded(
          rooms: const [],
          total: 0,
          blocStatus: BlocStatus.loaded,
        )) {
    on<PatientsFetch>(_onPatientsFetch);
  }

  _onPatientsFetch(PatientsFetch event, Emitter<PatientsState> emit) async {
    emit((state as PatientsLoaded).copyWith(
        patients: event.page > 1 ? state.rooms : [],
        blocStatus: BlocStatus.loading));
    Rooms roomsApi =
        await RoomApi().get(page: event.page, search: event.search ?? '');
    emit((state as PatientsLoaded).copyWith(
      blocStatus: BlocStatus.loaded,
      page: event.page,
      search: event.search ?? '',
      patients: [...state.rooms, ...roomsApi.rooms],
      hasReachedMax: roomsApi.rooms.length < 15,
      total: roomsApi.total,
    ));
  }
}
