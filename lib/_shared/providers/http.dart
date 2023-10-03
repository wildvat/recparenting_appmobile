import 'package:dio/dio.dart';
import 'package:recparenting/_shared/providers/interceptor_http.dart';
import 'package:recparenting/environments/env.dart';

class AuthHttp {
  Dio dio = Dio();
  AuthHttp() {
    dio.options.baseUrl = env.url;
    dio.options.headers['Accept'] = 'application/json';
    AuthInterceptors refreshFlow = AuthInterceptors(dio: dio);
    dio.interceptors.add(refreshFlow);
  }
}

class AuthApiHttp {
  Dio dio = Dio();
  AuthApiHttp() {
    dio.options.baseUrl = env.apiUrl;
    dio.options.headers['Accept'] = 'application/json';
    AuthInterceptors refreshFlow = AuthInterceptors(dio: dio);
    dio.interceptors.add(refreshFlow);
  }
}

class GenericApiHttp {
  Dio dio = Dio();
  GenericApiHttp() {
    dio.options.baseUrl = env.apiUrl;
    dio.options.headers['Accept'] = 'application/json';
    /*
    dio.options.headers['x-control-origin'] = env.authorizationRecMobile;
    */
  }
}

class GenericHttp {
  Dio dio = Dio();
  GenericHttp() {
    dio.options.baseUrl = env.url;
    dio.options.headers['Accept'] = 'application/json';
    /*
    dio.options.headers['x-control-origin'] = env.authorizationRecMobile;
    */
  }
}
