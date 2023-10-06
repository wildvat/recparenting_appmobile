part of 'patients_bloc.dart';

sealed class PatientsEvent extends Equatable {
  const PatientsEvent();

  @override
  List<Object> get props => [];
}

class PatientsFetch extends PatientsEvent {
  final int page;
  final String? search;
  const PatientsFetch({required this.page, this.search});
}
