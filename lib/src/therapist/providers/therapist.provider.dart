import 'package:dio/dio.dart';
import 'package:recparenting/_shared/providers/dio_provider.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';
import 'dart:developer' as developer;
import 'package:recparenting/_shared/models/user.model.dart';

import '../models/therapists-active.model.dart';

class TherapistApi {
  late User user;
  Dio client = dioApi;
  Future<TherapistActive?> getTherapistActive() async {
    const String endpoint = 'therapist';
    try {
      Response response = await client.get(endpoint);
      if (response.statusCode == 200) {
        TherapistActive therapist = TherapistActive.fromJson(response.data);
        return therapist;
      } else {
        return null;
      }
    } on DioException catch (e) {
      developer.log('/** ERROR TherapistApi.getAll **/');
      developer.log(e.response.toString());
      return null;
    }
  }

  Future<Therapist?> getById(String id) async {
    String endpoint = 'therapist/$id';
    try {
      Response response = await client.get(endpoint);
      if (response.statusCode == 200) {
        Therapist therapist = Therapist.fromJson(response.data);
        return therapist;
      } else {
        return null;
      }
    } on DioException catch (e) {
      developer.log('/** ERROR TherapistApi.getById **/');
      developer.log(e.response.toString());
      return null;
    }
  }
}
