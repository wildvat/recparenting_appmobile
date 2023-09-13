import 'package:recparenting/_shared/models/user.model.dart';

class Message{
  late String id;
  late String message;
  late String type;
  late String room;
  late User user;
  late bool isDeleted;
  late DateTime createdAt;

  Message(this.id, this.message, this.type, this.room, this.user,
      this.isDeleted, this.createdAt);

  Message.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    message = json['message'];
    type = json['type'];
    room = json['room'];
    user = User.fromJson(json['user']);
    isDeleted = json['is_deleted'];
    createdAt = DateTime.parse(json['created_at']);
  }
}