import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recparenting/navigator_key.dart';
import 'package:recparenting/src/current_user/bloc/current_user_bloc.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';
import 'dart:developer' as developer;
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/_shared/providers/http.dart';
import 'package:recparenting/src/auth/repository/token_respository.dart';

class CurrentUserApi {
  late User user;
  final AuthApiHttp client = AuthApiHttp();
  final CurrentUserBloc _currentUserBloc =
      BlocProvider.of<CurrentUserBloc>(navigatorKey.currentContext!);

  final TokenRepository _tokenRepository = TokenRepository();

  Future<User?> getUser() async {
    if (_currentUserBloc.state is CurrentUserLoaded) {
      return (_currentUserBloc.state as CurrentUserLoaded).user;
    }
    const String endpoint = 'user/me';
    try {
      Response response = await client.dio.get(endpoint);
      if (response.statusCode == 200) {
        User user = User.fromJson(response.data);
        if (user.type == 'patient') {
          user = Patient.fromJson(response.data);
        } else if (user.type == 'therapist') {
          user = Therapist.fromJson(response.data);
        } else {
          return null;
        }
        _currentUserBloc.add(FetchCurrentUser(user));
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

  Future<User?> reloadUser() async {

    const String endpoint = 'user/me';
    try {
      Response response = await client.dio.get(endpoint);
      if (response.statusCode == 200) {
        User user = User.fromJson(response.data);
        if (user.type == 'patient') {
          user = Patient.fromJson(response.data);
        } else if (user.type == 'therapist') {
          user = Therapist.fromJson(response.data);
        } else {
          return null;
        }
        _currentUserBloc.add(FetchCurrentUser(user));
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
      if (response.statusCode == 201) {
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

  void removeUser() {
    _currentUserBloc.add(CurrentUserInitialize());
  }
}
