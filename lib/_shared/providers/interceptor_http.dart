import 'package:dio/dio.dart';
import 'dart:developer' as developer;

import 'package:recparenting/_shared/providers/http.dart';
import 'package:recparenting/environments/env.dart';
import 'package:recparenting/src/auth/providers/login.provider.dart';
import 'package:recparenting/src/auth/repository/token_respository.dart';

/// Adds Authorization header with a non-expired bearer token.
///
/// Logic:
/// 1. Check if the endpoint requires authentication
///   - If not, bypass interceptor
/// 2. Get a non-expired access token
///   - AuthRepository takes care of refreshing the token if it is expired
/// 3. Make API call (attaching token in Authorization header)
/// 4. If response if 401 (e.g. a not expired access token that was revoked by backend),
///    force refresh access token and retry call.
///
/// For non-authenticated endpoints add the following header to bypass this interceptor:
/// `Authorization: None`
///
/// For endpoints with optional authentication provide the following header:
/// `Authorization: Optional`
/// - If user is not authenticated: the Authorization header will be removed
///   and the call will be performed without it.
/// - If the user is authenticated: the authentication token will be attached in the
///   Authorization header.
class AuthInterceptors extends QueuedInterceptor {
  AuthInterceptors({
    required this.dio,
    this.retries = 3,
  });

  /// The original dio
  final Dio dio;

  /// The number of retries in case of 401
  final int retries;

  final TokenRepository _tokenRepository = TokenRepository();
  final AuthApi _authApi = AuthApi();
  final GenericHttp _refreshDio = GenericHttp();

  @override
  Future<void> onRequest(
    final RequestOptions options,
    final RequestInterceptorHandler handler,
  ) async {
    String accessToken = await _tokenRepository.getToken();
    if (accessToken == '') {
      _authApi.logout();
      return;
    }

    options._setXControlOrigin();
    options._setAuthenticationHeader(accessToken);
    handler.next(options);
  }

  @override
  Future<void> onError(
      final DioException err, final ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return super.onError(err, handler);
    }

    // Check retry attempt
    final attempt = err.requestOptions._retryAttempt + 1;
    if (attempt > retries) {
      return super.onError(err, handler);
    }

    // todo remove delayed in order to lock
    err.requestOptions._retryAttempt = attempt;
    await Future<void>.delayed(const Duration(seconds: 1));

    // Force refresh auth token
    await _getRefreshFromApi(err.requestOptions, handler);
  }

  Future<void> _onErrorRefreshingToken() async {
    _authApi.logout();
  }

  Future<Response?> _getRefreshFromApi(
      RequestOptions options, ErrorInterceptorHandler handler) async {
    developer.log('Try to refresh token');
    final String accessToken = await _tokenRepository.getToken();
    if (accessToken == '') {
      _authApi.logout();
      return null;
    }
    String refreshToken = await _tokenRepository.getRefreshToken();
    final Map<String, String> data = {
      "grant_type": "refresh_token",
      "client_id": env.clientId,
      "client_secret": env.clientSecret,
      "refresh_token": refreshToken
    };
    Response responseRefresh = await _refreshDio.dio.post(
      "oauth/token",
      data: data,
    );
    if (responseRefresh.statusCode == 401) {
      developer.log('entra refreshToken errr 401');
      _authApi.logout();
      return null;
    }
    options._setXControlOrigin();
    options._setAuthenticationHeader(accessToken);
    await _tokenRepository.setToken(responseRefresh.data['access_token']);
    await _tokenRepository
        .setRefreshToken(responseRefresh.data['refresh_token']);
    try {
      final Response response = await dio.fetch(options);
      handler.resolve(response);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _onErrorRefreshingToken();
      }
      super.onError(e, handler);
    }
    return null;
  }
}

extension AuthRequestOptionsX on RequestOptions {
  void _setAuthenticationHeader(final String token) =>
      headers['Authorization'] = 'Bearer $token';

  void _setXControlOrigin() =>
      headers['x-control-origin'] = env.authorizationRecMobile;

  int get _retryAttempt => (extra['auth_retry_attempt'] as int?) ?? 0;

  set _retryAttempt(final int attempt) => extra['auth_retry_attempt'] = attempt;
}
