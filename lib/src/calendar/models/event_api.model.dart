import 'package:recparenting/_shared/models/user.model.dart';

class EventApiModel {
  late String id;
  late String type;
  late User user;
  EventApiModel({required this.id, required this.type, required this.user});

  EventApiModel.fromJson(Map<String, dynamic> json) {
    id = json['uuid'];
    type = json['type'];
    user = User.fromJson(json['user']);
  }
}
