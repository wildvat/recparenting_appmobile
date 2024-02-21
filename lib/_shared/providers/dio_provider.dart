import 'package:dio/dio.dart';
import 'package:recparenting/_shared/providers/interceptor_api_http.dart';
import 'package:recparenting/environments/env.dart';

final Dio dioApi = Dio(
  BaseOptions(
    baseUrl: env.apiUrl,
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 20),
  ),
)..interceptors.add(
    authApiInterceptor,
  );
