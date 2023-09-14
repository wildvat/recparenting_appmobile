/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recparenting/src/conference/models/response_enums.dart';

import '../interfaces/attendee.dart';
import '../interfaces/audio_video_interface.dart';
import '../interfaces/realtime_interface.dart';
import '../interfaces/video_tile.dart';
import '../interfaces/video_tile_interface.dart';
import 'meeting_view_model.dart';



class MethodChannelCoordinator extends ChangeNotifier {
  final MethodChannel methodChannel = const MethodChannel("appmobile.recparenting.methodChannel");

  RealtimeInterface? realtimeObserver;
  VideoTileInterface? videoTileObserver;
  AudioVideoInterface? audioVideoObserver;

  void initializeMethodCallHandler() {
    methodChannel.setMethodCallHandler(methodCallHandler);
    print("Flutter Method Call Handler initialized.");
  }

  void initializeRealtimeObserver(RealtimeInterface realtimeInterface) {
    realtimeObserver = realtimeInterface;
  }

  void initializeAudioVideoObserver(AudioVideoInterface audioVideoInterface) {
    audioVideoObserver = audioVideoInterface;
  }

  void initializeVideoTileObserver(VideoTileInterface videoTileInterface) {
    videoTileObserver = videoTileInterface;
  }

  void initializeObservers(MeetingViewModel meetingProvider) {
    initializeRealtimeObserver(meetingProvider);
    initializeAudioVideoObserver(meetingProvider);
    initializeVideoTileObserver(meetingProvider);
    print("Observers initialized");
  }

  Future<MethodChannelResponse?> callMethod(String methodName, [dynamic args]) async {
    print("Calling $methodName through method channel with args: $args");
    try {
      dynamic response = await methodChannel.invokeMethod(methodName, args);
      print('**************************************************');
      print('response callMetdo $methodName');
      print(response);
      print('**************************************************');

      return MethodChannelResponse.fromJson(response);
    } catch (e) {
      print('**************************************************');
      print('entre en error callMetdo $methodName');
      print(e.toString());
      print('**************************************************');

      return MethodChannelResponse(false, null);
    }
  }

  Future<void> methodCallHandler(MethodCall call) async {
    print("Recieved method call ${call.method} with arguments: ${call.arguments}");

    switch (call.method) {
      case MethodCallOption.join:
        final Attendee attendee = Attendee.fromJson(call.arguments);
        realtimeObserver?.attendeeDidJoin(attendee);
        print('**************************************************');
        print('añado un attendee');
        print('**************************************************');

        break;
      case MethodCallOption.leave:
        final Attendee attendee = Attendee.fromJson(call.arguments);
        realtimeObserver?.attendeeDidLeave(attendee, didDrop: false);
        print('**************************************************');
        print('salgo de la conferecen');
        print(attendee);
        print('**************************************************');

        break;
      case MethodCallOption.drop:
        final Attendee attendee = Attendee.fromJson(call.arguments);
        realtimeObserver?.attendeeDidLeave(attendee, didDrop: true);
        print('**************************************************');
        print('drop de la conferecen');
        print(attendee);
        print('**************************************************');
        break;
      case MethodCallOption.mute:
        final Attendee attendee = Attendee.fromJson(call.arguments);
        realtimeObserver?.attendeeDidMute(attendee);
        print('**************************************************');
        print('lo pongo en mute');
        print('**************************************************');
        break;
      case MethodCallOption.unmute:
        final Attendee attendee = Attendee.fromJson(call.arguments);
        realtimeObserver?.attendeeDidUnmute(attendee);
        print('**************************************************');
        print('lo pongo con sonido');
        print('**************************************************');


        break;
      case MethodCallOption.videoTileAdd:
        final String attendeeId = call.arguments["attendeeId"];
        final VideoTile videoTile = VideoTile.fromJson(call.arguments);
        videoTileObserver?.videoTileDidAdd(attendeeId, videoTile);
        print('**************************************************');
        print('añado un video');
        print('**************************************************');

        break;
      case MethodCallOption.videoTileRemove:
        final String attendeeId = call.arguments["attendeeId"];
        final VideoTile videoTile = VideoTile.fromJson(call.arguments);
        videoTileObserver?.videoTileDidRemove(attendeeId, videoTile);
        print('**************************************************');
        print('quito un video');
        print('**************************************************');
        break;
      case MethodCallOption.audioSessionDidStop:
        audioVideoObserver?.audioSessionDidStop();
        print('**************************************************');
        print('audioSessionDidStop');
        print('**************************************************');
        break;
      default:
        print('**************************************************');
        print("Method ${call.method} with args ${call.arguments} does not exist");
        print('**************************************************');

    }
  }
}

class MethodChannelResponse {
  late bool result;
  dynamic arguments;

  MethodChannelResponse(this.result, this.arguments);

  factory MethodChannelResponse.fromJson(dynamic json) {
    return MethodChannelResponse(json["result"], json["arguments"]);
  }
}
