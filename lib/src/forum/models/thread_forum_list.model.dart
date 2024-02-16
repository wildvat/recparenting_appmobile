import 'package:recparenting/src/forum/models/message.forum.dart';

class ThreadForumList {
  late List<MessageForum?> messages;
  late int total;
  ThreadForumList({
    required this.messages,
    required this.total,
  });

  ThreadForumList.fromJson(Map<String, dynamic> json) {
    List messagesFromApi = json['items'];
    if (messagesFromApi.isNotEmpty) {
      messages = messagesFromApi.map((e) => MessageForum.fromJson(e)).toList();
    } else {
      messages = [];
    }
    total = json['total'];
  }

  ThreadForumList.mock()
      : messages = [],
        total = 0;
}
