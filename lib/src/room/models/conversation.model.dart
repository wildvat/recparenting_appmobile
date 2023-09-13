import 'package:recparenting/src/room/models/room.model.dart';

import 'messages.model.dart';

class Conversation{
  late Messages messages;
  late Room room;

  Conversation(this.messages, this.room);

  Conversation.fromJson(Map<String, dynamic> json){
    messages = Messages.fromJson(json['messages']);
    room = Room.fromJson(json['room']);
  }
}