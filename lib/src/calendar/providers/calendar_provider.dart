import 'package:dio/dio.dart' as dio;
import 'package:recparenting/_shared/models/user.model.dart';
import 'dart:developer' as developer;

import 'package:recparenting/_shared/providers/http.dart';
import 'package:recparenting/src/calendar/models/events_para_integrar.model.dart';
import 'package:recparenting/src/calendar/models/events_api.model.dart';

class CalendarApi {
  AuthApiHttp client = AuthApiHttp();

  Future<EventsApiModel> getTherapistEvents(
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
        return EventsApiModel.fromJson(response.data, currentUser);
      }
      return EventsApiModel.mock(currentUser);
    } on dio.DioException catch (e) {
      developer.log('/** ERROR CurrentUserApi.getUser **/');
      developer.log(e.response.toString());
      return EventsApiModel.mock(currentUser);
    }
  }

  Future<EventsModelNew?> getPatientEvents(
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
        EventsModelNew events =
            EventsModelNew.fromJson(response.data['events']);
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
