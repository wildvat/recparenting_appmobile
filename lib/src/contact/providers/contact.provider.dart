import 'dart:developer' as dev;
import 'package:dio/dio.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/providers/dio_provider.dart';
import 'package:recparenting/_shared/providers/r_language.dart';
import 'package:recparenting/_shared/ui/widgets/snack_bar.widget.dart';

class ContactApi {
  final Dio _client = dioApi;

  Future<bool> sendMessage(String message) async {
    try {
      final response =
          await _client.post('contact', data: {'message': message});
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
    } on DioException catch (e) {
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

  Future<bool> requestDeleteAccount(String message) async {
    message = 'This user requests to delete their account. $message';
    return sendMessage(message);
  }
}
