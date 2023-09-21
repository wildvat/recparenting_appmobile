import 'package:dio/dio.dart' as dio;
import 'package:recparenting/_shared/models/user.model.dart';
import 'dart:developer' as developer;

import 'package:recparenting/_shared/providers/http.dart';
import 'package:recparenting/src/calendar/models/events.model.dart';
import 'package:recparenting/src/calendar/models/events_calendar_api.model.dart';

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
        EventsModel events =
            EventsModel.fromJson(response.data['events']);
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
}
