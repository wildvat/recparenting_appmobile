import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:recparenting/src/calendar/models/events_color.enum.dart';
import 'package:recparenting/src/therapist/models/working-hours.model.dart';

class EventsApiModel {
  late WorkingHours workingHours;
  late EventsModel events;
  EventsApiModel({required this.workingHours, required this.events});

  EventsApiModel.fromJson(Map<String, dynamic> json) {
    workingHours = WorkingHours.fromJson(json['working_hours']);
    events = EventsModel.fromJson(json['events']);
  }

  factory EventsApiModel.mock() {
    return EventsApiModel(
        workingHours: WorkingHours(),
        events: EventsModel(events: [], total: 0));
  }
}

class EventsModel {
  late List<CalendarEventData?> events;
  late int total;
  EventsModel({required this.events, required this.total});

  EventsModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    List eventsToCalendar = json['items'];
    if (eventsToCalendar.isNotEmpty) {
      events = eventsToCalendar.map((event) {
        return CalendarEventData(
            title: event['title'],
            date: DateTime.parse(event['start']),
            startTime: DateTime.parse(event['start']),
            endTime: DateTime.parse(event['end']),
            color: calendarEventsColors[event['type']] ?? Colors.grey);
      }).toList();
    } else {
      events = [];
    }
  }
}
