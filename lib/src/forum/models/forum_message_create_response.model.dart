import 'package:recparenting/src/forum/models/message.forum.dart';

class ForumMessageCreateResponse {
  final String? error;
  final MessageForum? message;
  const ForumMessageCreateResponse({this.error, this.message});
}
