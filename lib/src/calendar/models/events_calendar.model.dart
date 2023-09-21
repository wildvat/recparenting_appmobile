import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/src/calendar/models/event.model.dart';
import 'package:recparenting/src/calendar/models/event_calendar_api.model.dart';
import 'package:recparenting/src/calendar/models/events_color.enum.dart';

class EventsCalendarModel {
  late List<CalendarEventData?> events;
  late int total;
  EventsCalendarModel({required this.events, required this.total});

  EventsCalendarModel.fromJson(Map<String, dynamic> json, User currentUser) {
    try {
      Color color;
      total = json['total'];
      List eventsToCalendar = json['items'];
      if (eventsToCalendar.isNotEmpty) {

        events = eventsToCalendar.map((event) {
          //TODO: El modelo EventModel lleva incorporado los iconos y los colores ver si se puede recoger el color desde el eventModel y borrar este
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
              event: EventCalendarApiModel.fromJson(event),//TODO: ver si se puede cambiar por el generio EventModel
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