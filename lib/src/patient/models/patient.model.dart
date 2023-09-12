import 'package:recparenting/_shared/models/user-config.model.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';
import 'package:recparenting/_shared/models/user.model.dart';

class Patient extends User {
  late final Therapist? therapist;
  late final String conference;
  late final String room;
  late final String subscription;

  Patient(
      String id,
      String name,
      String lastname,
      String? nickname,
      String? email,
      String status,
      bool verified,
      String? avatar,
      List<String> roles,
      String permission,
      String type,
      UserConfig config,
      this.therapist,
      this.conference,
      this.room,
      this.subscription)
      : super(id, name, lastname, nickname, email, status, verified, avatar, roles,
            permission, type, config);

  factory Patient.fromJson(Map<String, dynamic> json) {
    User user = User.fromJson(json);
    late Therapist? therapist;
    if (json['therapist'] != null) {
      therapist = Therapist.fromJson(json['therapist']);
    }
    return Patient(
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
        therapist,
        json['conference'],
        json['room'],
        json['subscription']);
  }
  /*
  @override
  toJson() {

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
     // 'config': config.toJson(),
      //'therapist': therapist != null ? therapist!.toJson() : null,
      'conference': conference,
      'room': room,
      'subscription': subscription
    };
  }*/
}
