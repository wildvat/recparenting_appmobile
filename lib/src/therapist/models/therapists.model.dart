import 'package:recparenting/src/therapist/models/therapist.model.dart';

class Therapists {
  late final int total;
  late final List<Therapist?> users;

  Therapists({required this.total, required this.users});

  Therapists.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    List usersApi = json['items'];
    if (usersApi.isNotEmpty) {
      users = usersApi.map((item) {
        return Therapist.fromJson(item);
      }).toList();
    }
  }
}
