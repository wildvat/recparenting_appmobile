import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:recparenting/_shared/helpers/request_permission.dart';

import '../../src/current_user/providers/current_user.provider.dart';


getPermissionPushApp() async {
  var permission = RequestPermissions();
  NotificationSettings settings = await permission.push();

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }

  String platform = '';
  if (Platform.isIOS) {
    platform = 'ios';
  } else if (Platform.isAndroid) {
    platform = 'android';
  } else {
    platform = 'undefined';
  }
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  String? token = await firebaseMessaging.getToken();

  CurrentUserApi().addDevice(token!, platform);
}
