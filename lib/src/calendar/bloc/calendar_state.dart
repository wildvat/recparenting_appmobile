part of 'calendar_bloc.dart';

sealed class CalendarState extends Equatable {
  int total = 0;
  List<CalendarEventData?> events = [];
  BlocStatus blocStatus = BlocStatus.loading;
  bool hasReachedMax = false;
  int page = 1;

  CalendarState({
    required this.total,
    required this.events,
    required this.blocStatus,
    required this.hasReachedMax,
    required this.page,
  });

  @override
  List<Object> get props => [total, events, blocStatus, page];
}

final class CalendarLoaded extends CalendarState {
  CalendarLoaded(
      {required super.total,
      required super.events,
      super.blocStatus = BlocStatus.loading,
      super.hasReachedMax = false,
      super.page = 1});

  CalendarLoaded copyWith(
          {int? total,
          List<CalendarEventData?>? events,
          BlocStatus? blocStatus,
          bool? hasReachedMax,
          int? page}) =>
      CalendarLoaded(
          total: total ?? super.total,
          events: events ?? super.events,
          blocStatus: blocStatus ?? super.blocStatus,
          hasReachedMax: hasReachedMax ?? super.hasReachedMax,
          page: page ?? super.page);
}
