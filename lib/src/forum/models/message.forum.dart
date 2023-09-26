import 'package:recparenting/_shared/models/file_rec.model.dart';
import 'package:recparenting/_shared/models/user.model.dart';

class MessageForum {
  final String id;
  final String forumId;
  final DateTime createdAt;
  final User user;
  final MessageForum? parent;
  final String message;
  final List<FileRec> files;
  MessageForum({
    required this.id,
    required this.forumId,
    required this.createdAt,
    required this.user,
    required this.message,
    this.files = const [],
    this.parent,
  });

  MessageForum.fromJson(Map<String, dynamic> json)
      : id = json['uuid'],
        forumId = json['forum_id'],
        createdAt = DateTime.parse(json['created_at']),
        user = User.fromJson(json['user']),
        message = json['message'],
        files = json['files'] != null
            ? List<FileRec>.from(json['files'].map((x) => FileRec.fromJson(x)))
            : [],
        parent = json['parent'] != null
            ? MessageForum.fromJson(json['parent'])
            : null;
}
