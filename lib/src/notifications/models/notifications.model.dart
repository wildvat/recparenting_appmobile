import 'package:recparenting/src/notifications/models/notification.model.dart';

class Notifications{
  int total;
  List<NotificationRec> notifications;
  Notifications({required this.total, required this.notifications});

  Notifications.fromJson(Map<String, dynamic> json) :
    total = json['total'],
    notifications = json['items'].map<NotificationRec>((item) => NotificationRec.fromJson(item)).toList();

}