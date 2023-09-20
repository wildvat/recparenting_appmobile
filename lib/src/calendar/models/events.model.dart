import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/src/calendar/models/event_api.model.dart';
import 'package:recparenting/src/calendar/models/events_color.enum.dart';

class EventsModel {
  late List<CalendarEventData?> events;
  late int total;
  EventsModel({required this.events, required this.total});

  EventsModel.fromJson(Map<String, dynamic> json, User currentUser) {
    try {
      Color color;
      total = json['total'];
      List eventsToCalendar = json['items'];
      if (eventsToCalendar.isNotEmpty) {
        events = eventsToCalendar.map((event) {
          if (currentUser.isPatient() &&
              currentUser.id != event['user']['uuid']) {
            color = Colors.red;
          } else {
            color = calendarEventsColors[event['type']] ?? Colors.grey;
          }
          return CalendarEventData(
              title: currentUser.isPatient() &&
                      currentUser.id != event['user']['uuid']
                  ? '----'
                  : event['title'],
              date: DateTime.parse(event['start']).toLocal(),
              startTime: DateTime.parse(event['start']).toLocal(),
              endTime: DateTime.parse(event['end']).toLocal(),
              event: EventApiModel.fromJson(event),
              color: color);
        }).toList();
      } else {
        events = [];
      }
    } catch (e) {
      print(e.toString());
      total = 0;
      events = [];
    }
  }
}
