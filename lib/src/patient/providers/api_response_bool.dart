import 'package:recparenting/_shared/models/api_response.dart';

class ApiResponseBool extends ApiResponse{
  @override
  final bool data;
  ApiResponseBool(code, error, this.data) : super(code: code, data: data, error: error);
}