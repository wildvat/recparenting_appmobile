import 'package:recparenting/src/patient/models/patient.model.dart';

class Patients {
  late final int total;
  late final List<Patient?> users;

  Patients({required this.total, required this.users});

  Patients.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    List usersApi = json['items'];
    if (usersApi.isNotEmpty) {
      users = usersApi.map((item) {
        return Patient.fromJson(item);
      }).toList();
    }
  }
}
