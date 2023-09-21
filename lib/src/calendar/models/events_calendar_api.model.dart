import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/src/calendar/models/events_calendar.model.dart';
import 'package:recparenting/src/therapist/models/working-hours.model.dart';

class EventsCalendarApiModel {
  late WorkingHours workingHours;
  late EventsCalendarModel events;
  EventsCalendarApiModel({required this.workingHours, required this.events});

  EventsCalendarApiModel.fromJson(Map<String, dynamic> json, User currentUser) {
    workingHours = WorkingHours.fromJson(json['working_hours']);
    events = EventsCalendarModel.fromJson(json['events'], currentUser);
  }


  factory EventsCalendarApiModel.mock(User currentUser) {
    return EventsCalendarApiModel(
        workingHours: WorkingHours(),
        events: EventsCalendarModel(events: [], total: 0));
  }
}
