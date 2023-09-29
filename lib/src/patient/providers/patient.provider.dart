import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:recparenting/_shared/ui/widgets/snack_bar.widget.dart';
import 'package:recparenting/src/patient/models/change_therapist.model.dart';
import 'package:recparenting/src/patient/models/change_therapist_reasons.enum.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/patient/providers/api_response_bool.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';
import 'dart:developer' as developer;
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/_shared/providers/http.dart';
import 'package:recparenting/src/auth/repository/token_respository.dart';

import '../../../environments/env.dart';

class PatientApi {
  late User user;
  AuthApiHttp client = AuthApiHttp();
  final String _baseUrl = env.apiUrl;

  final TokenRepository _tokenRepository = TokenRepository();

  Future<User?> getAll() async {
    String endpoint = '${_baseUrl}patient';
    try {
      Response response = await client.dio.get(endpoint);
      if (response.statusCode == 200) {
        User user = User.fromJson(response.data);
        if (user.type == 'patient') {
          user = Patient.fromJson(response.data);
        }
        if (user.type == 'therapist') {
          user = Therapist.fromJson(response.data);
        }
        return user;
      } else {
        _tokenRepository.clearTokens();
        return null;
      }
    } on DioException catch (e) {
      developer.log('/** ERROR CurrentUserApi.getUser **/');
      developer.log(e.response.toString());
      _tokenRepository.clearTokens();
      return null;
    }
  }

  Future<ChangeTherapist?> requestChangeTherapist(String therapistId, ChangeTherapistReasons reason) async {
    String endpoint = '${_baseUrl}therapist/$therapistId/change';
    try {
      Map<String, dynamic> body = {
        'reason': convertChangeTherapistReasonToString(reason),
      };
      Response response = await client.dio.post(
        endpoint,
        data: FormData.fromMap(body),
      );
      if (response.statusCode == 200) {
        return ChangeTherapist.fromJson(response.data);
      } else {
        return null;
      }
    } on DioException catch (e) {
      SnackBarRec( message: e.response?.data['message']);
      developer.log('/** ERROR RoomApi.sendMessage **/');
      developer.log(e.response.toString());
      return null;
    }
  }

  Future<ChangeTherapist?> hasRequestChangeTherapist(String therapistId) async {
    String endpoint = '${_baseUrl}therapist/$therapistId/change';
    try {

      Response response = await client.dio.get(endpoint);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ChangeTherapist.fromJson(response.data);
      }
        return null;

    } on DioException catch (e) {
      developer.log('/** ERROR PatientApi.hasRequestChangeTherapist **/');
      developer.log(e.toString());
      developer.log('entor en exception');
      developer.log(e.message.toString());

      throw Exception(e.message.toString());
    }
  }


  Future<ApiResponseBool> sharedRoomWith(String therapistId, bool shared) async {

    String endpoint = '${_baseUrl}conversation/user/$therapistId/shared';
    try {
      Map<String, dynamic> body = {
        'shared': shared?'shared':'remove',
      };
      Response response = await client.dio.post(
        endpoint,
        data: FormData.fromMap(body),
      );
      if (response.statusCode == 200) {
        return ApiResponseBool(response.statusCode??200, null, false);
      }else if(response.statusCode == 201) {
        return ApiResponseBool(response.statusCode??201, null, true);
      } else {
        return ApiResponseBool(response.statusCode??500, response.data.toString(), false);
      }
    } on DioException catch (e) {
      developer.log(jsonDecode(e.response.toString())['message']);
      return ApiResponseBool(500, jsonDecode(e.response.toString())['message'], false);
    }
  }


  Future<ApiResponseBool> isSharedRoomWith(String therapistId)
  async {

    String endpoint = '${_baseUrl}conversation/user/$therapistId/shared';
    try {
      Response response = await client.dio.get(endpoint);
      print(response.statusCode);
      if (response.statusCode == 201) {
        return ApiResponseBool(response.statusCode??201, null, response.data['is_shared']);
      }
      return ApiResponseBool(500, '', false);
    } on DioException catch (e) {
      return ApiResponseBool(500, e.message.toString(), false);
    }

  }
}
