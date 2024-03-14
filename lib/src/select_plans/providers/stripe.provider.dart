import 'package:dio/dio.dart';
import 'package:recparenting/environments/env.dart';
import 'dart:developer' as dev;

import 'package:recparenting/src/select_plans/models/products.model.dart';

class StripeApi {
  final Dio _dio = Dio();

  StripeApi() {
    _dio.options.baseUrl = env.url;
    _dio.options.headers['Accept'] = 'application/json';
  }

  Future<Products> getPlans() async {
    final String endpoint =
        'products?salt=${DateTime.now().millisecondsSinceEpoch}';
    try {
      final Response response = await _dio.get(endpoint);
      if (response.statusCode == 200) {
        return Products.fromJson(response.data);
      }
      return Products(list: []);
    } on DioException catch (e) {
      dev.log(e.toString());
      return Products(list: []);
    } catch (e) {
      dev.log(e.toString());
      return Products(list: []);
    }
  }
}
