import 'package:dio/dio.dart';
import 'package:recparenting/_shared/providers/dio_provider.dart';
import 'package:recparenting/src/notifications/models/notifications.model.dart';
import '../../../environments/env.dart';
import 'dart:developer' as developer;

class NotificationApi {
  final Dio client = dioApi;
  final String _baseUrl = env.apiUrl;

  Future<Notifications?> getAll() async {
    String endpoint = '${_baseUrl}notifications';
    try {
      Response response = await client.get(endpoint);
      if (response.statusCode == 200) {
        return Notifications.fromJson(response.data);
      }
      developer.log(
          '/** STATUS CODE ${response.statusCode} NotificationApi.getAll **/');
      return null;
    } on DioException catch (e) {
      developer.log('/** ERROR NotificationApi.getAll **/');
      developer.log(e.response.toString());
      return null;
    }
  }

  Future<void> markAsRead(String? notificationId) async {
    String endpoint = '${_baseUrl}notifications';
    Map<String, dynamic> body = {};
    try {
      if (notificationId != null) {
        body['notification'] = notificationId;
      }
      await client.post(
        endpoint,
        data: FormData.fromMap(body),
      );
    } on DioException catch (e) {
      developer.log('/** ERROR RoomApi.sendMessage **/');
      developer.log(e.response.toString());
    }
  }
}
