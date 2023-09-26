import 'package:recparenting/src/therapist/models/therapist-data.model.dart';

import '../../../_shared/models/user-config.model.dart';
import '../../../_shared/models/user.model.dart';

class Therapist extends User {
  late final TherapistData data;

  Therapist(
      String id,
      String name,
      String? lastname,
      String? nickname,
      String? email,
      String status,
      bool verified,
      String avatar,
      List<String> roles,
      String permission,
      String type,
      UserConfig config,
      this.data)
      : super(id, name, lastname, email, nickname, status, verified, avatar,
            roles, permission, type, config);

  String getFullName() {
    return '$name $lastname';
  }

  factory Therapist.fromJson(Map<String, dynamic> json) {
    User user = User.fromJson(json);
    return Therapist(
        user.id,
        user.name,
        user.lastname,
        user.nickname,
        user.email,
        user.status,
        user.verified,
        user.avatar,
        user.roles,
        user.permission,
        user.type,
        user.config,
        TherapistData.fromJson(json['data']));
  }
/*
  @override
  toJson() {
    dev.log('therapist data');
    dev.log(data);
    return {
      'id': id,
      'name': name,
      'lastname': lastname,
      'email': email,
      'status': status,
      'verified': verified,
      'avatar': avatar,
      'roles': roles,
      'permission': permission,
      'type': type,
      'config': config.toJson(),
      'data': data.toJson()
    };
  }*/
}
