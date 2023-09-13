import 'package:dio/dio.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';
import 'dart:developer' as developer;
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/_shared/providers/http.dart';
import 'package:recparenting/src/auth/repository/token_respository.dart';

class PatientApi {
  late User user;
  AuthApiHttp client = AuthApiHttp();

  final TokenRepository _tokenRepository = TokenRepository();

  Future<User?> getAll() async {
    const String endpoint = 'patient';
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
}
