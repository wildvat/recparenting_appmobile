class User {
  late final String id;
  late final String name;
  late final String email;
  late final String? phone;
  late final bool isActive;
  late final String? avatar;
  late final bool status;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.isActive,
      this.avatar,
      this.status = false});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    isActive = json['status'] == 1 ? true : false;
    avatar = json['logo'] != null ? json['logo']['url'] : null;
    status = (json['status'] != null && json['status'] == 1) ? true : false;
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'status': isActive ? 1 : 0,
      'logo': avatar != null ? {'url': avatar} : null,
    };
  }
}
