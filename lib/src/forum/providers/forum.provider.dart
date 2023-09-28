import 'package:dio/dio.dart' as dio;
import 'package:recparenting/_shared/providers/http.dart';
import 'package:recparenting/_shared/providers/r_language.dart';
import 'package:recparenting/src/forum/models/forum.list.model.dart';
import 'package:recparenting/src/forum/models/forum_create_response.model.dart';
import 'package:recparenting/src/forum/models/forum_message_create_response.model.dart';
import 'package:recparenting/src/forum/models/forum_status.enum.dart';
import 'package:recparenting/src/forum/models/message.forum.dart';
import 'package:recparenting/src/forum/models/thread.model.dart';

class ForumApi {
  AuthApiHttp client = AuthApiHttp();

  Future<ForumList> getThreads({
    int? page = 1,
    String? search = '',
  }) async {
    final String endpoint =
        'forum?page=$page&search=$search&status=${ForunMessageStatus.active.name} ';
    try {
      final response = await client.dio.get(endpoint);
      if (response.statusCode == 200) {
        return ForumList.fromJson(response.data);
      }
      return ForumList.mock();
    } on dio.DioException catch (e) {
      print(e);
      return ForumList.mock();
    }
  }

  Future<ForumCreateResponse> createThread(
      String title, String description) async {
    const String endpoint = 'forum';
    try {
      final response = await client.dio.post(endpoint, data: {
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
    } on dio.DioException catch (e) {
      print(e);
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
      List<String>? files}) async {
    final String endpoint = 'forum/$threadId';
    try {
      Map<String, dynamic> data = {'comment': comment};
      if (files != null) {
        List<dio.MultipartFile> filesToApi = [];
        for (final attach in files) {
          final dio.MultipartFile file =
              await dio.MultipartFile.fromFile(attach);
          filesToApi.add(file);
        }
        data['files[]'] = files;
      }

      final dio.FormData formData = dio.FormData.fromMap(data);
      final response = await client.dio.post(endpoint, data: formData);
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return ForumMessageCreateResponse(
          message: MessageForum.fromJson(response.data),
        );
      }
      return const ForumMessageCreateResponse(error: 'Error');
    } on dio.DioException catch (e) {
      print(e);
      String responseError = R.string.generalError;
      if (e.response?.data != null) {
        responseError = e.response!.data['message'];
      }
      return ForumMessageCreateResponse(error: responseError);
    }
  }
}
