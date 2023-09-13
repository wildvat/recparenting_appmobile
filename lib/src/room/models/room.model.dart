import 'package:recparenting/src/room/models/message.model.dart';

import '../../../_shared/models/user.model.dart';

class Room {
  late String id;
  late bool hasPermissionToWrite;
  late Message? lastMessage;
  late List<User> participants;
  late bool isActive;
  late bool isRead;

  Room(this.id, this.hasPermissionToWrite, this.lastMessage, this.participants,
      this.isActive, this.isRead);

  Room.fromJson(Map<String, dynamic> json){
    id = json['_id'];
    hasPermissionToWrite = json['has_permission_to_write'];
    lastMessage = json['last_message'] != null
        ? Message.fromJson(json['last_message'])
        : null;
    participants =
    List<User>.from(json['participants'].map((x) => User.fromJson(x)));
    isActive = json['is_active'];
    isRead = json['is_read'];
  }


}