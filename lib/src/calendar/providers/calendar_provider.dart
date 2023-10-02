import 'package:calendar_view/calendar_view.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:recparenting/_shared/models/user.model.dart';
import 'dart:developer' as developer;

import 'package:recparenting/_shared/providers/http.dart';
import 'package:recparenting/_shared/providers/r_language.dart';
import 'package:recparenting/src/calendar/models/create_event_api_response.dart';
import 'package:recparenting/src/calendar/models/event_calendar_api.model.dart';
import 'package:recparenting/src/calendar/models/events.model.dart';
import 'package:recparenting/src/calendar/models/events_calendar_api.model.dart';
import 'package:recparenting/src/calendar/models/events_color.enum.dart';

class CalendarApi {
  AuthApiHttp client = AuthApiHttp();

  Future<EventsCalendarApiModel> getTherapistEvents(
      {required String therapist,
      required DateTime start,
      required DateTime end,
      required User currentUser,
      int? page = 1}) async {
    const String endpoint = 'calendar/user';
    final String startToApi = start.toUtc().toString();
    final String endToApi = end.toUtc().toString();
    try {
      dio.Response response = await client.dio
          .get('$endpoint/$therapist?start=$startToApi&end=$endToApi');
      if (response.statusCode == 200) {
        return EventsCalendarApiModel.fromJson(response.data, currentUser);
      }
      return EventsCalendarApiModel.mock(currentUser);
    } on dio.DioException catch (e) {
      developer.log('/** ERROR CurrentUserApi.getUser **/');
      developer.log(e.response.toString());
      return EventsCalendarApiModel.mock(currentUser);
    }
  }

  Future<EventsModel?> getPatientEvents(
      {required String patientId,
      required DateTime start,
      required DateTime end,
      required User currentUser,
      int? page = 1}) async {
    const String endpoint = 'calendar/user';
    final String startToApi = start.toUtc().toString();
    final String endToApi = end.toUtc().toString();
    try {
      dio.Response response = await client.dio
          .get('$endpoint/$patientId?start=$startToApi&end=$endToApi');
      if (response.statusCode == 200) {
        EventsModel events = EventsModel.fromJson(response.data['events']);
        return events;
      }
      return null;
    } on dio.DioException catch (_) {
      return null;
    }
  }

  Future<bool> deleteEvent(String idEvent) async {
    final String endpoint = 'calendar/event/$idEvent';
    try {
      dio.Response response = await client.dio.delete(endpoint);
      if (response.statusCode == 204) {
        return true;
      }
      return false;
    } on dio.DioException catch (e) {
      developer.log('/** ERROR CurrentUserApi.deleteEvent **/');
      developer.log(e.response.toString());
      return false;
    }
  }

  Future<CreateEventApiResponse> createEvent(
      {required User currentUser,
      required String userId,
      required String modelType,
      required String modelId,
      required String title,
      required String type,
      required DateTime start,
      required DateTime end}) async {
    const String endpoint = 'calendar/event';
    try {
      dio.Response response = await client.dio.post(endpoint, data: {
        'user_id': userId,
        'model_type': modelType,
        'model_id': modelId,
        'title': title,
        'decription': '',
        'type': type,
        'start': start.toUtc().toString(),
        'end': end.toUtc().toString(),
      });
      if ([201, 204].contains(response.statusCode)) {
        Color color;
        if (currentUser.isPatient() &&
            currentUser.id != response.data['user']['uuid']) {
          color = Colors.red;
        } else {
          color = calendarEventsColors[response.data['type']] ?? Colors.grey;
        }
        return CreateEventApiResponse(
            event: CalendarEventData(
                title: currentUser.isPatient() &&
                        currentUser.id != response.data['user']['uuid']
                    ? '----'
                    : response.data['title'],
                date: DateTime.parse(response.data['start']).toLocal(),
                startTime: DateTime.parse(response.data['start']).toLocal(),
                endTime: DateTime.parse(response.data['end']).toLocal(),
                event: EventCalendarApiModel.fromJson(response.data),
                color: color));
      }

      return CreateEventApiResponse(error: R.string.generalError);
    } on dio.DioException catch (e) {
      developer.log('/** ERROR CurrentUserApi.deleteEvent **/');
      developer.log(e.response?.data.toString() ?? 'No message');
      String responseError = R.string.generalError;
      if (e.response?.data != null) {
        responseError = e.response!.data['message'];
      }
      return CreateEventApiResponse(error: responseError);
    }
  }
}
