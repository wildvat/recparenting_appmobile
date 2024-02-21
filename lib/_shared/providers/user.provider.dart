import 'package:dio/dio.dart';
import 'package:recparenting/_shared/providers/dio_provider.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';
import 'dart:developer' as developer;
import 'package:recparenting/_shared/models/user.model.dart';

class UserApi {
  late User user;
  final Dio client = dioApi;

  Future<User?> getUserById(String id) async {
    String endpoint = 'user/$id';
    try {
      Response response = await client.get(endpoint);
      if (response.statusCode == 200) {
        User user = User.fromJson(response.data);
        if (user.type == 'patient') {
          user = Patient.fromJson(response.data);
        } else if (user.type == 'therapist') {
          user = Therapist.fromJson(response.data);
        } else {
          return null;
        }
        return user;
      } else {
        return null;
      }
    } on DioException catch (e) {
      developer.log('/** ERROR UserApi.getUserById **/');
      developer.log(e.response.toString());
      return null;
    }
  }
}
