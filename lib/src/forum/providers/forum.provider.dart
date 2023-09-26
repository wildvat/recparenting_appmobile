import 'package:dio/dio.dart' as dio;
import 'package:recparenting/_shared/providers/http.dart';
import 'package:recparenting/src/forum/models/forum.list.model.dart';

class ForumApi {
  AuthApiHttp client = AuthApiHttp();

  Future<ForumList> getThreads({
    int? page = 1,
    String? search = '',
  }) async {
    final String endpoint = 'forum?page=$page&search=$search';
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
