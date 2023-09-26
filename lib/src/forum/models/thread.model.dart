import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/src/forum/models/message.forum.dart';

class ThreadForum {
  final String id;
  final DateTime createdAt;
  final String description;
  final String title;
  final User createdBy;
  final MessageForum? lastMessage;

  int totalMessages;

  ThreadForum(
      {required this.id,
      required this.createdAt,
      required this.title,
      required this.description,
      required this.totalMessages,
      required this.createdBy,
      this.lastMessage});

  ThreadForum.fromJson(Map<String, dynamic> json)
      : id = json['uuid'],
        createdAt = DateTime.parse(json['created_at']),
        description = json['description'],
        title = json['title'],
        totalMessages = json['total_messages'],
        createdBy = User.fromJson(json['created_by']),
        lastMessage = json['last_message'] != null
            ? MessageForum.fromJson(json['last_message'])
            : null;
}
