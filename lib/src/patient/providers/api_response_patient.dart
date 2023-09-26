import 'package:recparenting/_shared/models/api_response.dart';

import '../models/patient.model.dart';

class ApiResponsePatient extends ApiResponse{
  @override
  final int code;
  @override
  final String? error;
  @override
  final Patient? data;

  ApiResponsePatient(this.code, this.error, this.data) : super(code: code, data: data, error: error);


}