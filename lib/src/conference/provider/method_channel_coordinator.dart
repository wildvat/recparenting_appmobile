/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recparenting/src/conference/models/response_enums.dart';

import '../models/attendee.dart';
import '../interfaces/audio_video_interface.dart';
import '../interfaces/realtime_interface.dart';
import '../models/video_tile.dart';
import '../interfaces/video_tile_interface.dart';
import '../provider/meeting_provider.dart';
import 'dart:developer' as developer;

class MethodChannelCoordinator extends ChangeNotifier {
  final MethodChannel methodChannel =
      const MethodChannel("appmobile.recparenting.methodChannel");

  RealtimeInterface? realtimeObserver;
  VideoTileInterface? videoTileObserver;
  AudioVideoInterface? audioVideoObserver;

  void initializeMethodCallHandler() {
    methodChannel.setMethodCallHandler(methodCallHandler);
    developer.log("Flutter Method Call Handler initialized.");
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

  void initializeObservers(MeetingProvider meetingProvider) {
    developer.log(
        '***********************INITIALIZE OBSERVERS**********************************');
    initializeRealtimeObserver(meetingProvider);
    initializeAudioVideoObserver(meetingProvider);
    initializeVideoTileObserver(meetingProvider);
  }

  Future<MethodChannelResponse?> callMethod(String methodName,
      [dynamic args]) async {
    developer
        .log("Calling $methodName through method channel with args: $args");
    try {
      dynamic response = await methodChannel.invokeMethod(methodName, args);
      developer.log('**************************************************');
      developer.log('response callMethod $methodName');

/*
  Widget _dayDetectorBuilder(
    DateTime date,
    List<CalendarEventData> events,
    Rect boundary,
    DateTime startDuration,
    DateTime endDuration,
  ) {
    */
      (response);
      developer.log('**************************************************');

      return MethodChannelResponse.fromJson(response);
    } catch (e) {
      developer.log('**************************************************');
      developer.log('entre en error callMethod $methodName');
      developer.log(e.toString());
      developer.log('**************************************************');

      return MethodChannelResponse(false, null);
    }
  }

  Future<void> methodCallHandler(MethodCall call) async {
    developer.log(
        "Recieved method call ${call.method} with arguments: ${call.arguments}");

    switch (call.method) {
      case MethodCallOption.join:
        final Attendee attendee = Attendee.fromJson(call.arguments);
        realtimeObserver?.attendeeDidJoin(attendee);
        developer.log('**************************************************');
        developer.log('añado un attendee');
        developer.log('**************************************************');

        break;
      case MethodCallOption.leave:
        final Attendee attendee = Attendee.fromJson(call.arguments);
        realtimeObserver?.attendeeDidLeave(attendee, didDrop: false);
        developer.log('**************************************************');
        developer.log('salgo de la conferecen');
        developer.log(attendee.toString());
        developer.log('**************************************************');

        break;
      case MethodCallOption.drop:
        final Attendee attendee = Attendee.fromJson(call.arguments);
        realtimeObserver?.attendeeDidLeave(attendee, didDrop: true);
        developer.log('**************************************************');
        developer.log('drop de la conferecen');
        developer.log(attendee.toString());
        developer.log('**************************************************');
        break;
      case MethodCallOption.mute:
        final Attendee attendee = Attendee.fromJson(call.arguments);
        realtimeObserver?.attendeeDidMute(attendee);
        developer.log('**************************************************');
        developer.log('lo pongo en mute');
        developer.log('**************************************************');
        break;
      case MethodCallOption.unmute:
        final Attendee attendee = Attendee.fromJson(call.arguments);
        realtimeObserver?.attendeeDidUnmute(attendee);
        developer.log('**************************************************');
        developer.log('lo pongo con sonido');
        developer.log('**************************************************');

        break;
      case MethodCallOption.videoTileAdd:
        final String attendeeId = call.arguments["attendeeId"];
        final VideoTile videoTile = VideoTile.fromJson(call.arguments);
        videoTileObserver?.videoTileDidAdd(attendeeId, videoTile);
        developer.log('**************************************************');
        developer.log('añado un video');
        developer.log('**************************************************');

        break;
      case MethodCallOption.videoTileRemove:
        final String attendeeId = call.arguments["attendeeId"];
        final VideoTile videoTile = VideoTile.fromJson(call.arguments);
        videoTileObserver?.videoTileDidRemove(attendeeId, videoTile);
        developer.log('**************************************************');
        developer.log('quito un video');
        developer.log('**************************************************');
        break;
      case MethodCallOption.audioSessionDidStop:
        audioVideoObserver?.audioSessionDidStop();
        developer.log('**************************************************');
        developer.log('audioSessionDidStop');
        developer.log('**************************************************');
        break;
      default:
        developer.log('**************************************************');
        developer.log(
            "Method ${call.method} with args ${call.arguments} does not exist");
        developer.log('**************************************************');
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
