import 'package:recparenting/_shared/models/user.model.dart';

class EventCalendarApiModel {
  late String id;
  late String type;
  late User user;
  EventCalendarApiModel({required this.id, required this.type, required this.user});

  EventCalendarApiModel.fromJson(Map<String, dynamic> json) {
    id = json['uuid'];
    type = json['type'];
    user = User.fromJson(json['user']);
  }
}