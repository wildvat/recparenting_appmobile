import 'dart:convert';
import 'dart:developer' as developer;

import 'package:crypto/crypto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:recparenting/environments/env.dart';
import 'package:recparenting/src/auth/repository/token_respository.dart';
import 'package:recparenting/src/room/models/message.model.dart';
import '../bloc/conversation_bloc.dart';

class ChatApi {

  late ConversationBloc _conversationBloc;

  ChatApi(context){
    _conversationBloc = BlocProvider.of<ConversationBloc>(context);

  }
  final PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  Future<void> connect(String roomId) async {
    try {
      await pusher.init(
        apiKey: env.pusherAppKey,
        cluster: env.pusherAppCluster,
        authEndpoint: '${env.url}broadcasting/auth',
        authParams: {
          'headers': {'Authorization': 'Bearer ${TokenRepository().getToken()}'}
        },
        onEvent: onEvent,
        onError: onError,
        onConnectionStateChange: onConnectionStateChange,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onSubscriptionError: onSubscriptionError,
        onDecryptionFailure: onDecryptionFailure,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved,
        onSubscriptionCount: onSubscriptionCount,
        onAuthorizer: onAuthorizer,
        logToConsole: true,
      );
      await pusher.subscribe(channelName: 'private-conversation.$roomId');
      await pusher.connect();
    } on Exception catch (error) {
      developer.log(error.toString());
    }

    return;
  }

  getSignature(String value) {
    var key = utf8.encode(env.pusherAppSecret);
    var bytes = utf8.encode(value);
    var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
    var digest = hmacSha256.convert(bytes);
    developer.log("HMAC signature in string is: $digest");
    return digest;
  }

  dynamic onAuthorizer(String channelName, String socketId, dynamic options) {
    return {
      "auth": "${env.pusherAppKey}:${getSignature("$socketId:$channelName")}",
      //"channel_data": '{"user_id": 10}',
      //"shared_secret": "foobar"
    };
  }

  void onError(String error, int? number, dynamic) =>
      developer.log('ErrorPusher: ${error.toString()}');

  void onConnectionStateChange(String stateCurrent, String statePrev) =>
      developer.log('State: $stateCurrent');

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    developer.log("onSubscriptionSucceeded: $channelName data: $data");
    final me = pusher.getChannel(channelName)?.me;
    developer.log("Me: $me");
  }

  void onEvent(PusherEvent event) {
    try {
      if (event.eventName == 'new-message') {
        Message message = Message.fromJson(jsonDecode(event.data));
        _conversationBloc.add(ReceiveMessageToConversation(message: message));
      }
    } catch (e) {
      developer.log("onEventError: ${e.toString()}");
    }
  }

  void onSubscriptionError(String message, dynamic e) {
    developer.log("onSubscriptionError: $message Exception: $e");
  }

  void onDecryptionFailure(String event, String reason) {
    developer.log("onDecryptionFailure: $event reason: $reason");
  }

  void onMemberAdded(String channelName, PusherMember member) {
    developer.log("onMemberAdded: $channelName user: $member");
  }

  void onMemberRemoved(String channelName, PusherMember member) {
    developer.log("onMemberRemoved: $channelName user: $member");
  }

  void onSubscriptionCount(String channelName, int subscriptionCount) {
    developer.log(
        "onSubscriptionCount: $channelName subscriptionCount: $subscriptionCount");
  }

}
