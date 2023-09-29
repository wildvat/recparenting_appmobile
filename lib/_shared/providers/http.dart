import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:recparenting/_shared/providers/interceptor_http.dart';
import 'package:recparenting/environments/env.dart';

class AuthHttp {
  Dio dio = Dio();
  AuthHttp() {
    dio.options.baseUrl = env.url;
    dio.options.headers['Accept'] = 'application/json';
    AuthInterceptors refreshFlow = AuthInterceptors(dio: dio);
    dio.interceptors.add(refreshFlow);

    //TODO: remove this line cuando funcione el certificado
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };
  }
}

class AuthApiHttp {
  Dio dio = Dio();
  AuthApiHttp() {
    dio.options.baseUrl = env.apiUrl;
    dio.options.headers['Accept'] = 'application/json';
    AuthInterceptors refreshFlow = AuthInterceptors(dio: dio);
    dio.interceptors.add(refreshFlow);
    //TODO: remove this line cuando funcione el certificado
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };
  }
}

class GenericApiHttp {
  Dio dio = Dio();
  GenericApiHttp() {
    dio.options.baseUrl = env.apiUrl;
    dio.options.headers['Accept'] = 'application/json';
    //TODO: remove this line cuando funcione el certificado
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };
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
    //TODO: remove this line cuando funcione el certificado
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };
    /*
    dio.options.headers['x-control-origin'] = env.authorizationRecMobile;
    */
  }
}
