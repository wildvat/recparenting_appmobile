part of 'calendar_bloc.dart';

sealed class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object> get props => [];
}

class CalendarEventsFetch extends CalendarEvent {
  final int? page;
  final DateTime start;
  final DateTime end;
  const CalendarEventsFetch(
      {required this.page, required this.start, required this.end});
}
