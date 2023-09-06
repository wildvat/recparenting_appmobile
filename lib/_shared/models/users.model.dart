import 'package:recparenting/_shared/models/user.model.dart';

class Users {
  late final int total;
  late final List<User?> users;

  Users({required this.total, required this.users});

  Users.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    List usersApi = json['users'];
    if (usersApi.isNotEmpty) {
      users = usersApi.map((item) {
        return User.fromJson(item);
      }).toList();
    }
  }
}
