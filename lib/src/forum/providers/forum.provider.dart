import 'package:dio/dio.dart' as dio;
import 'package:recparenting/_shared/providers/http.dart';
import 'package:recparenting/_shared/providers/r_language.dart';
import 'package:recparenting/src/forum/models/forum.list.model.dart';
import 'package:recparenting/src/forum/models/forum_create_response.model.dart';
import 'package:recparenting/src/forum/models/forum_status.enum.dart';
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
}


/*
if (message.attachments.isNotEmpty) {
  List<MultipartFile> files = [];
  for (final attach in message.attachments) {
    final MultipartFile file = await MultipartFile.fromFile(attach!);
    files.add(file);
  }
  data['files[]'] = files;
}

final FormData formData = FormData.fromMap(data);
*/
