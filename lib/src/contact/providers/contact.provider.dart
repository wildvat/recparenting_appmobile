import 'package:dio/dio.dart' as dio;
import 'dart:developer' as dev;
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/providers/http.dart';
import 'package:recparenting/_shared/providers/r_language.dart';
import 'package:recparenting/_shared/ui/widgets/snack_bar.widget.dart';
import 'package:recparenting/environments/env.dart';

class ContactApi {
  final String _baseUrl = env.apiUrl;
  final AuthApiHttp _client = AuthApiHttp();

  Future<bool> sendMessage(String message) async {
    try {
      final response = await _client.dio
          .post('${_baseUrl}contact', data: {'message': message});
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        SnackBarRec(
            message: R.string.generalOk,
            backgroundColor: TextColors.success.color);
        return true;
      }
      SnackBarRec(
          message: R.string.generalError,
          backgroundColor: TextColors.danger.color);
      return false;
    } on dio.DioException catch (e) {
      dev.log(e.toString());
      String responseError = R.string.generalError;
      if (e.response?.data != null) {
        responseError = e.response!.data['message'];
      }
      SnackBarRec(
          message: responseError, backgroundColor: TextColors.danger.color);
      return false;
    }
  }
}
