import 'package:dio/dio.dart';
import 'package:recparenting/src/room/models/conversation.model.dart';
import 'package:recparenting/src/room/models/message.model.dart';
import 'dart:developer' as developer;
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/_shared/providers/http.dart';

import '../../../environments/env.dart';
import '../models/rooms.model.dart';

class RoomApi {
  late User user;
  AuthApiHttp client = AuthApiHttp();
  final String _baseUrl = env.apiUrl;

  Future<Rooms?> getAll(int? page, int? limit) async {
    String endpoint = '${_baseUrl}conversation';
    bool queryAdded = false;
    if (page != null) {
      endpoint = '$endpoint?page=$page';
      queryAdded = true;
    }

    if (limit != null) {
      endpoint = '$endpoint${(queryAdded ? '&' : '?')}limit=$limit';
    }
    try {
      Response response = await client.dio.get(endpoint);
      if (response.statusCode == 200) {
        return Rooms.fromJson(response.data);
      } else {
        return null;
      }
    } on DioException catch (e) {
      developer.log('/** ERROR RoomApi.getAll **/');
      developer.log(e.response.toString());
      return null;
    }
  }

  Future<Conversation?> getConversation(String id, int? page) async {
    String endpoint = '${_baseUrl}conversation/$id';
    if (page != null) {
      endpoint = '$endpoint?page=$page';
    }

    try {
      Response response = await client.dio.get(endpoint);
      if (response.statusCode == 200) {
        return Conversation.fromJson(response.data);
      } else {
        return null;
      }
    } on DioException catch (e) {
      developer.log('/** ERROR RoomApi.getConversation **/');
      developer.log(e.response.toString());
      return null;
    }
  }

  Future<Conversation?> getConversationWithUser(User user) async {
    String endpoint = '${_baseUrl}conversation/user/${user.id}';
    try {
      Response response = await client.dio.get(endpoint);
      if (response.statusCode == 200) {
        return Conversation.fromJson(response.data);
      } else {
        return null;
      }
    } on DioException catch (e) {
      developer.log('/** ERROR RoomApi.getConversationWithUser **/');
      developer.log(e.response.toString());
      return null;
    }
  }

  Future<Rooms?> getConversationSharedPatientWithTherapist(User user) async {
    String endpoint = '${_baseUrl}patient/${user.id}/shared/conversations';
    try {
      Response response = await client.dio.get(endpoint);
      if (response.statusCode == 200) {
        return Rooms.fromJson(response.data);
      } else {
        return null;
      }
    } on DioException catch (e) {
      developer.log('/** ERROR RoomApi.getConversationWithUser **/');
      developer.log(e.response.toString());
      return null;
    }
  }

  Future<Message?> sendMessage(String roomId, Message message) async {
    String endpoint = '${_baseUrl}conversation/$roomId';
    try {
      Map<String, dynamic> body = {
        'type': message.type,
        'message': message.message,
      };
      Response response = await client.dio.post(
        endpoint,
        data: FormData.fromMap(body),
      );
      if (response.statusCode == 200) {
        return Message.fromJson(response.data);
      } else {
        return null;
      }
    } on DioException catch (e) {
      developer.log('/** ERROR RoomApi.sendMessage **/');
      developer.log(e.response.toString());
      return null;
    }
  }

  /*
  Future<Room?> createConversation(User user, Patient patient, Message message) async {
    String endpoint = 'conversation';
    try {
      Map<String, dynamic> body = {
        'type': message.type,
        'message': message.message,
      };
      Response response = await client.dio.post(
        endpoint,
        data: FormData.fromMap(body),
      );
      if (response.statusCode == 200) {
        return Room.fromJson(response.data);
      } else {
        return null;
      }
    } on DioException catch (e) {
      developer.log('/** ERROR RoomApi.getConversationWithUser **/');
      developer.log(e.response.toString());
      return null;
    }
  }

   */
  Future<void> deleteMessage(String idConversation, String idMessage) async {
    String endpoint =
        '${_baseUrl}conversation/$idConversation/message/$idMessage';
    try {
      Response response = await client.dio.delete(endpoint);
      if (response.statusCode == 200) {
        return;
      } else {
        return;
      }
    } on DioException catch (e) {
      developer.log('/** ERROR RoomApi.deleteMessage **/');
      developer.log(e.response.toString());
      return;
    }
  }

  Future<void> deleteConversation(String id) async {
    String endpoint = '${_baseUrl}conversation/$id';
    try {
      Response response = await client.dio.delete(endpoint);
      if (response.statusCode == 200) {
        return;
      } else {
        return;
      }
    } on DioException catch (e) {
      developer.log('/** ERROR RoomApi.deleteMessage **/');
      developer.log(e.response.toString());
      return;
    }
  }
}
