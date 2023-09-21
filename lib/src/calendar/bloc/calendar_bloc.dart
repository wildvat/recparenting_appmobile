import 'package:bloc/bloc.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:equatable/equatable.dart';
import 'package:recparenting/_shared/models/bloc_status.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final EventController eventController;
  final String therapistId;

  CalendarBloc({required this.eventController, required this.therapistId})
      : super(CalendarLoaded(events: const [], total: 0)) {
    CalendarLoaded currentState = (state as CalendarLoaded);

    on<CalendarEventsFetch>((event, emit) async {
      /*
      EventsApiModel calendarApiModel = await CalendarApi().getTherapistEvents(
          therapist: therapistId,
          end: event.end,
          start: event.start,
          page: event.page);

      if (calendarApiModel.events.events.isNotEmpty) {
        eventController
            .addAll(calendarApiModel.events.events.nonNulls.toList());
      }
      */
      /*
      emit(currentState.copyWith(
          page: event.page,
          total: calendarApiModel.events.total,
          events: calendarApiModel.events.events));
          */
    });
  }
}
