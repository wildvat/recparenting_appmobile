import 'package:recparenting/_shared/models/api_response.dart';
import 'package:recparenting/src/room/models/room.model.dart';

class ApiResponseRoom extends ApiResponse{
  @override
  final int code;
  @override
  final String? error;
  @override
  final Room? data;

  ApiResponseRoom(this.code, this.error, this.data) : super(code: code, data: data, error: error);


}