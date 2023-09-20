import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/src/calendar/models/events.model.dart';
import 'package:recparenting/src/therapist/models/working-hours.model.dart';

class EventsApiModel {
  late WorkingHours workingHours;
  late EventsModel events;
  EventsApiModel({required this.workingHours, required this.events});

  EventsApiModel.fromJson(Map<String, dynamic> json, User currentUser) {
    workingHours = WorkingHours.fromJson(json['working_hours']);
    events = EventsModel.fromJson(json['events'], currentUser);
  }


  factory EventsApiModel.mock(User currentUser) {
    return EventsApiModel(
        workingHours: WorkingHours(),
        events: EventsModel(events: [], total: 0));
  }
}
