import 'package:dio/dio.dart';
import 'package:recparenting/environments/env.dart';

class GenericApiHttp {
  Dio dio = Dio();
  GenericApiHttp() {
    dio.options.baseUrl = env.apiUrl;
    dio.options.headers['Accept'] = 'application/json';
  }
}

class GenericHttp {
  Dio dio = Dio();
  GenericHttp() {
    dio.options.baseUrl = env.url;
    dio.options.headers['Accept'] = 'application/json';
  }
}
