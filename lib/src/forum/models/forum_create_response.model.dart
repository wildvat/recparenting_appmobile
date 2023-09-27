import 'package:recparenting/src/forum/models/thread.model.dart';

class ForumCreateResponse {
  final ThreadForum? thread;
  final String? error;
  const ForumCreateResponse({
    this.thread,
    this.error,
  });
}
