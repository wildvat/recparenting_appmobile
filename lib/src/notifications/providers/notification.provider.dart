import 'package:dio/dio.dart';
import 'package:recparenting/src/notifications/models/notifications.model.dart';

import '../../../_shared/providers/http.dart';
import '../../../environments/env.dart';
import 'dart:developer' as developer;

class NotificationApi{

  final AuthApiHttp client = AuthApiHttp();
  final String _baseUrl = env.apiUrl;

  Future<Notifications?> getAll() async {

    String endpoint = '${_baseUrl}notifications';
    try {
      Response response = await client.dio.get(endpoint);
      if (response.statusCode == 200) {
          return Notifications.fromJson(response.data);
        }
        return null;
    } on DioException catch (e) {
      developer.log('/** ERROR NotificationApi.getAll **/');
      developer.log(e.response.toString());
      return null;
    }
  }
  Future<void> markAsRead() async {
    String endpoint = '${_baseUrl}notifications';
    try {

      await client.dio.post(
        endpoint,
        data: null,
      );

    } on DioException catch (e) {
      developer.log('/** ERROR RoomApi.sendMessage **/');
      developer.log(e.response.toString());
    }
  }
}