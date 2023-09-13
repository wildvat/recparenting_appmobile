import 'dart:developer' as developer;

import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
//  import 'package:recparenting/_shared/providers/http.dart';
import 'package:recparenting/environments/env.dart';

class ChatApi {
  //  final AuthApiHttp _client = AuthApiHttp();
  final PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  void onError(String error, int? number, dynamic) =>
      developer.log('ErrorPusher: ${error.toString()}');

  void onConnectionStateChange(String stateCurrent, String statePrev) =>
      developer.log('State: $stateCurrent');

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    developer.log("onSubscriptionSucceeded: $channelName data: $data");
    final me = pusher.getChannel(channelName)?.me;
    developer.log("Me: $me");
  }

  Future<void> connect() async {
    try {
      await pusher.init(
        apiKey: env.pusherAppKey,
        cluster: env.pusherAppCluster,
        onError: onError,
        onConnectionStateChange: onConnectionStateChange,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
      );
      await pusher.connect();
    } on Exception catch (error) {
      developer.log(error.toString());
    }

    return;
  }
}
