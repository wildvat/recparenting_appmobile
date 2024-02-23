import 'package:recparenting/_shared/models/user-config.model.dart';

class User {
  late final String id;
  late final String name;
  late final String? lastname;
  late final String? nickname;
  late final String? email;
  late final String status;
  late final bool verified;
  late final String avatar;
  late final List<String> roles;
  late final String permission;
  late final String type;
  late final UserConfig config;

  User(
      this.id,
      this.name,
      this.lastname,
      this.nickname,
      this.email,
      this.status,
      this.verified,
      this.avatar,
      this.roles,
      this.permission,
      this.type,
      this.config);

  isActive() {
    if (status == 'active') {
      return true;
    }
    return false;
  }

  bool isAdminOrEmployee() {
    return false;
    //return roles.isNotEmpty && roles.map(role => ['admin', 'employee'].includes(role));
  }

  bool isAdmin() {
    /*
    if (roles.isNotEmpty && roles[0] == 'admin') {
      return true;
    }
     */
    return false;
  }

  bool isEmployee() {
    /*
    if (roles.isNotEmpty && roles[0] == 'employee') {
      return true;
    }
    */

    return false;
  }

  bool isAccountManager() {
    /*
    if (roles.isNotEmpty && roles[0] == 'employee' && permission == 'account-manager') {
      return true;
    }
     */
    return false;
  }

  bool isAnalytic() {
    /*
    if ( roles.isNotEmpty && roles[0] == 'employee' && permission == 'analytic') {
      return true;
    }

     */
    return false;
  }

  bool isPatient() {
    if (roles.isNotEmpty && roles[0] == 'patient') {
      return true;
    }
    return false;
  }

  bool isTherapist() {
    if (roles.isNotEmpty && roles[0] == 'therapist') {
      return true;
    }
    return false;
  }

  String getFullName() {
    if (isPatient()) {
      return nickname ?? '';
    }
    return '$name ${lastname ?? ''}';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    List apiRoles = json['roles'] as List;
    List<String> roles = apiRoles.map((i) => i.toString()).toList();
    bool verified = false;
    if (json['email_verified_at'] != null ||
        json['email_verified_at'] == true) {
      verified = true;
    }
    String permission = '';
    if (json['permission'] != null) {
      permission = json['permission'];
    }
    String avatar = json['image'];
    UserConfig config = UserConfig.fromJson(json['config']);
    String name = '';
    String lastName = '';
    if (json['type'] == 'patient') {
      name = json['nickname'];
    } else {
      name = json['name'];
      lastName = json['last_name'];
    }
    return User(
        json['uuid'],
        name,
        lastName,
        json['nickname'],
        json['email'],
        json['status'],
        verified,
        avatar,
        roles,
        permission,
        json['type'],
        config);
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'last_name': lastname,
      'email': email,
      'status': status,
      'verified': verified,
      'avatar': avatar,
      'roles': roles,
      'permission': permission,
      'type': type,
      'config': config.toJson()
    };
  }
}
