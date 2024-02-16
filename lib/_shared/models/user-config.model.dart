import 'package:recparenting/_shared/models/notification-user-permission.model.dart';

class UserConfig {
  late String? timezone;
  late String? language;
  late NotificationUserPermission notificationUserPermission;

  UserConfig(this.timezone, this.language, this.notificationUserPermission);

  UserConfig.fromJson(Map<String, dynamic> json){
    timezone = json['timezone'];
    language = json['language'];
    notificationUserPermission =
        NotificationUserPermission.fromJson(json['notifications']);
  }

  toJson(){
    return {
      'timezone': timezone,
      'language': language,
      'notifications': notificationUserPermission.toJson()
    };
  }
}