import 'package:recparenting/src/room/models/message.model.dart';

class Messages {
  late final int total;
  late final List<Message> messages;

  Messages({required this.total, required this.messages});

  Messages.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    List messagesApi = json['items'];
    if (messagesApi.isNotEmpty) {
      messages = messagesApi.map((item) {
        return Message.fromJson(item);
      }).toList();
    }else {
      messages = [];
    }
  }
}
