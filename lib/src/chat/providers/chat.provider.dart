import 'dart:developer' as developer;

import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
//  import 'package:recparenting/_shared/providers/http.dart';
import 'package:recparenting/environments/env.dart';

class ChatApi {
  //  final AuthApiHttp _client = AuthApiHttp();
  final PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  Future<void> connect() async {
    try {
      await pusher.init(
          apiKey: env.pusherAppKey, cluster: env.pusherAppCluster);
      await pusher.connect();
    } on Exception catch (error) {
      developer.log(error.toString());
    }

    return;
  }
}
