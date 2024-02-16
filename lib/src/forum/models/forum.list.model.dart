import 'package:recparenting/src/forum/models/thread.model.dart';

class ForumList {
  late List<ThreadForum?> threads;
  late int total;
  ForumList({required this.threads, required this.total});

  ForumList.fromJson(Map<String, dynamic> json) {
    List threadsApi = json['items'] ?? [];
    threads = threadsApi.map((x) => ThreadForum.fromJson(x)).toList();
    total = json['total'];
  }

  ForumList.mock()
      : threads = [],
        total = 0;
}
