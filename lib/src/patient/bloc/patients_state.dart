part of 'patients_bloc.dart';

sealed class PatientsState extends Equatable {
  List<Room?> rooms = [];
  int total = 0;
  BlocStatus blocStatus = BlocStatus.loading;
  int page = 1;
  String search = '';
  bool hasReachedMax = false;
}

final class PatientsLoaded extends PatientsState {
  List<Room?> rooms = [];
  int total = 0;
  BlocStatus blocStatus = BlocStatus.loading;
  int page;
  bool hasReachedMax;
  String search;
  PatientsLoaded(
      {required this.rooms,
      required this.total,
      this.blocStatus = BlocStatus.loading,
      this.page = 1,
      this.search = '',
      this.hasReachedMax = false});

  PatientsLoaded copyWith({
    List<Room?>? patients,
    int? total,
    BlocStatus? blocStatus,
    int? page,
    bool? hasReachedMax,
    String? search,
  }) =>
      PatientsLoaded(
        rooms: patients ?? this.rooms,
        total: total ?? this.total,
        page: page ?? this.page,
        search: search ?? this.search,
        blocStatus: blocStatus ?? this.blocStatus,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      );

  @override
  List<Object?> get props =>
      [rooms, search, total, blocStatus, page, hasReachedMax];
}
