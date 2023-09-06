import 'package:dio/dio.dart';
import 'dart:developer' as developer;
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/_shared/providers/http.dart';
import 'package:recparenting/src/auth/repository/token_respository.dart';
import 'package:recparenting/src/current_user/current_user.repository.dart';

class CurrentUserApi {
  late User user;
  AuthApiHttp client = AuthApiHttp();

  final CurrentUserRepository _currentUserRepository = CurrentUserRepository();
  final TokenRepository _tokenRepository = TokenRepository();

  Future<User?> getUser() async {
    const String endpoint = 'users/me';
    try {
      Response response = await client.dio.get(endpoint);
      if (response.statusCode == 200) {
        final User user = User.fromJson(response.data);
        _currentUserRepository.setPreferences(user);
        return user;
      } else {
        _currentUserRepository.clearCurrentUser();
        _tokenRepository.clearTokens();
        return null;
      }
    } on DioException catch (e) {
      developer.log('/** ERROR CurrentUserApi.getUser **/');
      developer.log(e.response.toString());
      _currentUserRepository.clearCurrentUser();
      _tokenRepository.clearTokens();
      return null;
    }
  }

  Future<String?> addDevice(String token, String platform) async {
    const String url = 'users/devices';
    Map<String, dynamic> body = {
      'token': token,
      'type': '--',
      'platform': platform
    };
    try {
      Response response =
          await client.dio.post(url, data: FormData.fromMap(body));
      if (response.statusCode == 200) {
        return token;
      } else {
        return null;
      }
    } on DioException catch (e) {
      developer.log('token device error');
      developer.log(e.error.toString());
      return null;
    }
  }
}
