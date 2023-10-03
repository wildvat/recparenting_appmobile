import 'package:dio/dio.dart';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/_shared/providers/http.dart';
import 'package:recparenting/_shared/providers/r_language.dart';
import 'package:recparenting/_shared/ui/widgets/snack_bar.widget.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:recparenting/environments/env.dart';
import 'package:recparenting/navigator_key.dart';
import 'package:recparenting/src/auth/models/login_model.dart';
import 'package:recparenting/src/auth/repository/token_respository.dart';
import 'package:recparenting/src/current_user/providers/current_user.provider.dart';

class AuthApi {
  final TokenRepository _tokenRepository = TokenRepository();
  final GenericHttp _client = GenericHttp();

  Future<User?> login({required String email, required String password}) async {
    try {
      final Response response = await _client.dio.post('oauth/token', data: {
        'username': email,
        'password': password,
        'grant_type': 'password',
        'client_id': env.clientId,
        'client_secret': env.clientSecret,
        'scope': '*'
      });
      if (response.statusCode == 200) {
        _tokenRepository.initializeTokens(TokenModel.fromJson(response.data));
        return await CurrentUserApi().getUser().then((User? userApi) async {
          if (userApi != null) {
            return userApi;
          } else {
            return null;
          }
        });
      } else {
        return null;
      }
    } on DioException catch (e) {
      developer.log('error 2');
      developer.log(e.toString());
      return null;
    }
  }

  Future<bool> passwordRecovery({required String email}) async {
    try {
      final Response response = await _client.dio.post('password/email', data: {
        'email': email,
      });
      if (response.statusCode == 200) {
        SnackBarRec(
          message: 'Se ha enviado un correo con las instrucciones',
          backgroundColor: Colors.green,
        );
        return true;
      } else {
        SnackBarRec(
          message: 'Se ha producido un error',
          backgroundColor: Colors.redAccent,
        );
      }
      return false;
    } on DioException catch (e) {
      developer.log('passwordRecovery');
      developer.log(e.toString());
      String responseError = R.string.generalError;
      if (e.response?.data != null) {
        responseError = e.response!.data['message'];
      }
      SnackBarRec(
        message: responseError,
        backgroundColor: Colors.redAccent,
      );
      return false;
    }
  }

  void logout() async {
    _tokenRepository.clearTokens();
    CurrentUserApi().removeUser();
    navigatorKey.currentState
        ?.pushNamedAndRemoveUntil(loginRoute, (Route<dynamic> route) => false);
    return;
  }
}
