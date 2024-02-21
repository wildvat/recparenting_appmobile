import 'package:dio/dio.dart';
import 'package:recparenting/_shared/providers/dio_provider.dart';
import 'package:recparenting/_shared/providers/http.dart';
import 'package:recparenting/environments/env.dart';
import 'package:recparenting/src/auth/providers/login.provider.dart';
import 'package:recparenting/src/auth/repository/token_respository.dart';
import 'dart:developer' as developer;

class AuthApiInterceptor extends InterceptorsWrapper {
  AuthApiInterceptor() {
    print('AuthApiInterceptor');
  }

  // when accessToken is expired & having multiple requests call
  // this variable to lock others request to make sure only trigger call refresh token 01 times
  // to prevent duplicate refresh call
  bool _isRefreshing = false;

  // when having multiple requests call at the same time, you need to store them in a list
  // then loop this list to retry every request later, after call refresh token success
  final _requestsNeedRetry =
      <({RequestOptions options, ErrorInterceptorHandler handler})>[];
  final TokenRepository _tokenRepository = TokenRepository();
  final AuthApi _authApi = AuthApi();
  final GenericHttp _refreshDio = GenericHttp();
  static const refreshUrl = 'oauth/token';

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('inbterceptor');
    String accessToken = await _tokenRepository.getToken();
    if (accessToken == '') {
      _authApi.logout();
      return;
    }

    /*options._setXControlOrigin();*/
    options._setAuthenticationHeader(accessToken);
    options._setHeadersJson();
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final response = err.response;
    print(response?.requestOptions.path);
    print(refreshUrl);
    print(_isRefreshing);
    if (response != null &&
        // status code for unauthorized usually 401
        response.statusCode == 401 &&
        // refresh token call maybe fail by it self
        // eg: when refreshToken also is expired -> can't get new accessToken
        // usually server also return 401 unauthorized for this case
        // need to exlude it to prevent loop infinite call
        response.requestOptions.path != refreshUrl) {
      // if hasn't not refreshing yet, let's start it
      if (!_isRefreshing) {
        _isRefreshing = true;

        // add request (requestOptions and handler) to queue and wait to retry later
        _requestsNeedRetry
            .add((options: response.requestOptions, handler: handler));

        // call api refresh token
        final isRefreshSuccess = await _refreshToken(err.requestOptions);
        print('isRefreshSuccess ${false}');
        _isRefreshing = false;

        if (isRefreshSuccess) {
          // refresh success, loop requests need retry
          for (var requestNeedRetry in _requestsNeedRetry) {
            print(requestNeedRetry.options.path);
            // don't need set new accessToken to header here, because these retry
            // will go through onRequest callback above (where new accessToken will be set to header)
            final retry = await dioApi.fetch(requestNeedRetry.options);
            print('retry response: ${retry.data.toString()}');
            requestNeedRetry.handler.resolve(retry);
          }
          _requestsNeedRetry.clear();
        } else {
          _requestsNeedRetry.clear();
          // if refresh fail, force logout user here
        }
      } else {
        // if refresh flow is processing, add this request to queue and wait to retry later
        _requestsNeedRetry
            .add((options: response.requestOptions, handler: handler));
      }
    } else {
      // ignore other error is not unauthorized
      return handler.next(err);
    }
  }

  Future<void> _onErrorRefreshingToken() async {
    _authApi.logout();
  }

  Future<bool> _refreshToken(RequestOptions options) async {
    try {
      print('init refreshToken');
      final String accessToken = await _tokenRepository.getToken();
      final String refreshToken = await _tokenRepository.getRefreshToken();
      if (accessToken == '' || refreshToken == '') {
        _onErrorRefreshingToken();
        return false;
      }
      try {
        final Map<String, String> data = {
          "grant_type": "refresh_token",
          "client_id": env.clientId,
          "client_secret": env.clientSecret,
          "refresh_token": refreshToken
        };
        print(refreshToken);
        Response responseRefresh = await _refreshDio.dio.post(
          refreshUrl,
          data: data,
        );
        print('loaded refreshToken');
        if (responseRefresh.statusCode == 401) {
          _onErrorRefreshingToken();
          return false;
        }
        print(responseRefresh.data['refresh_token']);
        options._setHeadersJson();
        options._setAuthenticationHeader(accessToken);
        await _tokenRepository.setToken(responseRefresh.data['access_token']);
        await _tokenRepository
            .setRefreshToken(responseRefresh.data['refresh_token']);
        return true;
      } on DioException catch (e) {
        print("refresh 22222 token fail ${e.toString()}");
        developer.log(e.toString());
        _authApi.logout();
        return false;
      }
    } catch (error) {
      print("refresh token fail ${error.toString()}");
      return false;
    }
  }
}

extension AuthRequestOptionsX on RequestOptions {
  void _setAuthenticationHeader(final String token) =>
      headers['Authorization'] = 'Bearer $token';
  void _setHeadersJson() => headers['Accept'] = 'application/json';
  /*
  void _setXControlOrigin() =>
      headers['x-control-origin'] = env.authorizationRecMobile;
  */
}

AuthApiInterceptor authApiInterceptor = AuthApiInterceptor();
