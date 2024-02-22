import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:recparenting/_shared/helpers/request_permission.dart';

import '../../src/current_user/providers/current_user.provider.dart';
import 'dart:developer' as dev;

getPermissionPushApp() async {
  var permission = RequestPermissions();
  NotificationSettings settings = await permission.push();
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    dev.log('User granted push permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    dev.log('User granted provisional push permission');
  } else {
    dev.log('User declined or has not accepted  push permission');
    return;
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
  if (token != null) {
    dev.log('token device: $token');
    CurrentUserApi().addDevice(token, platform);
  } else {
    dev.log('token device: null');
  }
}
