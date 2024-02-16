import 'package:recparenting/src/therapist/models/therapist.model.dart';
import 'package:recparenting/_shared/models/user.model.dart';

class Patient extends User {
  final Therapist? therapist;
  final String? conference;
  final String? room;
  late final String subscription;

  Patient(
      super.id,
      super.name,
      super.lastname,
      super.nickname,
      super.email,
      super.status,
      super.verified,
      super.avatar,
      super.roles,
      super.permission,
      super.type,
      super.config,
      this.therapist,
      this.conference,
      this.room,
      this.subscription);

  bool isMyCurrentTherapist(Therapist therapist) {
    if (this.therapist != null) {
      return this.therapist!.id == therapist.id;
    }
    return false;
  }

  factory Patient.fromJson(Map<String, dynamic> json) {
    User user = User.fromJson(json);
    Therapist? therapist;
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
