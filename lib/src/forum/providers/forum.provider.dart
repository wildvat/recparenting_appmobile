import 'dart:developer' as dev;
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:recparenting/_shared/providers/dio_provider.dart';
import 'package:recparenting/_shared/providers/r_language.dart';
import 'package:recparenting/_shared/ui/widgets/snack_bar.widget.dart';
import 'package:recparenting/src/forum/models/forum.list.model.dart';
import 'package:recparenting/src/forum/models/forum_create_response.model.dart';
import 'package:recparenting/src/forum/models/forum_message_create_response.model.dart';
import 'package:recparenting/src/forum/models/forum_status.enum.dart';
import 'package:recparenting/src/forum/models/message.forum.dart';
import 'package:recparenting/src/forum/models/thread.model.dart';
import 'package:recparenting/src/forum/models/thread_forum_list.model.dart';

class ForumApi {
  Dio client = dioApi;

  Future<ForumList> getThreads({
    int? page = 1,
    String? search = '',
  }) async {
    final String endpoint =
        'forum?page=$page&search=$search&status=${ForunMessageStatus.active.name} ';
    try {
      final response = await client.get(endpoint);
      if (response.statusCode == 200) {
        return ForumList.fromJson(response.data);
      }
      return ForumList.mock();
    } on DioException catch (e) {
      dev.log(e.toString());
      return ForumList.mock();
    }
  }

  Future<ForumCreateResponse> createThread(
      String title, String description) async {
    const String endpoint = 'forum';
    try {
      final response = await client.post(endpoint, data: {
        'title': title,
        'description': description,
      });
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return ForumCreateResponse(
          thread: ThreadForum.fromJson(response.data),
        );
      }
      return const ForumCreateResponse(error: 'Error');
    } on DioException catch (e) {
      dev.log(e.toString());
      String responseError = R.string.generalError;
      if (e.response?.data != null) {
        responseError = e.response!.data['message'];
      }
      return ForumCreateResponse(error: responseError);
    }
  }

  Future<ForumMessageCreateResponse> createMessage(
      {required String threadId,
      required String comment,
      String? parentId,
      List<PlatformFile> files = const []}) async {
    final String endpoint = 'forum/$threadId';
    try {
      Map<String, dynamic> data = {'message': comment};
      if (parentId != null) {
        data['parent'] = parentId;
      }
      if (files.isNotEmpty) {
        List<MultipartFile> filesToApi = [];
        for (final attach in files) {
          if (attach.path == null) continue;
          final MultipartFile file = await MultipartFile.fromFile(
            attach.path!,
            filename: attach.name,
          );
          filesToApi.add(file);
        }
        data['files[]'] = filesToApi;
      }

      final FormData formData = FormData.fromMap(data);
      final response = await client.post(endpoint, data: formData);
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return ForumMessageCreateResponse(
          message: MessageForum.fromJson(response.data),
        );
      }
      String responseError = R.string.generalError;
      if (response.data != null) {
        responseError = response.data['message'];
      }
      return ForumMessageCreateResponse(error: responseError.toString());
    } on DioException catch (e) {
      dev.log(e.toString());
      String responseError = R.string.generalError;
      if (e.response?.data != null) {
        responseError = e.response!.data['message'];
      }
      return ForumMessageCreateResponse(error: responseError);
    }
  }

  Future<ThreadForum?> getById({
    required String threadId,
    int? page = 1,
    String? search = '',
  }) async {
    final String endpoint = 'forum/$threadId/';
    try {
      final response = await client.get(endpoint);
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return ThreadForum.fromJson(response.data);
      }
      return null;
    } on DioException catch (_) {
      return null;
    }
  }

  Future<ThreadForumList> getMessagesFromThread({
    required String threadId,
    int? page = 1,
    String? search = '',
  }) async {
    final String endpoint =
        'forum/$threadId/messages?page=$page&search=$search&status=${ForunMessageStatus.active.name} ';
    try {
      final response = await client.get(endpoint);
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return ThreadForumList.fromJson(response.data);
      }
      return ThreadForumList.mock();
    } on DioException catch (e) {
      dev.log(e.toString());
      return ThreadForumList.mock();
    }
  }

  Future<bool> deleteMessage(String threadId, String messageID) async {
    final String endpoint = 'forum/$threadId/message/$messageID';
    try {
      final response = await client.delete(endpoint);
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        SnackBarRec(
          message: 'Mensaje eliminado correctamente',
          backgroundColor: Colors.green,
        );
        return true;
      }
      SnackBarRec(
        message: R.string.generalError,
        backgroundColor: Colors.red,
      );
      return false;
    } on DioException catch (e) {
      dev.log(e.toString());
      String responseError = R.string.generalError;
      if (e.response?.data != null) {
        responseError = e.response!.data['message'];
      }
      SnackBarRec(
        message: responseError,
        backgroundColor: Colors.red,
      );
      return false;
    }
  }
}
