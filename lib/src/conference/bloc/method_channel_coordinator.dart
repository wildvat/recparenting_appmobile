/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recparenting/src/conference/models/response_enums.dart';
import 'dart:developer' as dev;

import '../interfaces/attendee.dart';
import '../interfaces/audio_video_interface.dart';
import '../interfaces/realtime_interface.dart';
import '../interfaces/video_tile.dart';
import '../interfaces/video_tile_interface.dart';
import 'meeting_view_model.dart';

class MethodChannelCoordinator extends ChangeNotifier {
  final MethodChannel methodChannel =
      const MethodChannel("appmobile.recparenting.methodChannel");

  RealtimeInterface? realtimeObserver;
  VideoTileInterface? videoTileObserver;
  AudioVideoInterface? audioVideoObserver;

  void initializeMethodCallHandler() {
    methodChannel.setMethodCallHandler(methodCallHandler);
    dev.log("Flutter Method Call Handler initialized.");
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
    dev.log("Observers initialized");
  }

  Future<MethodChannelResponse?> callMethod(String methodName,
      [dynamic args]) async {
    dev.log("Calling $methodName through method channel with args: $args");
    try {
      dynamic response = await methodChannel.invokeMethod(methodName, args);
      dev.log('**************************************************');
      dev.log('response callMetdo $methodName');
      dev.log(response);
      dev.log('**************************************************');

      return MethodChannelResponse.fromJson(response);
    } catch (e) {
      dev.log('**************************************************');
      dev.log('entre en error callMetdo $methodName');
      dev.log(e.toString());
      dev.log('**************************************************');

      return MethodChannelResponse(false, null);
    }
  }

  Future<void> methodCallHandler(MethodCall call) async {
    dev.log(
        "Recieved method call ${call.method} with arguments: ${call.arguments}");

    switch (call.method) {
      case MethodCallOption.join:
        final Attendee attendee = Attendee.fromJson(call.arguments);
        realtimeObserver?.attendeeDidJoin(attendee);
        dev.log('**************************************************');
        dev.log('añado un attendee');
        dev.log('**************************************************');

        break;
      case MethodCallOption.leave:
        final Attendee attendee = Attendee.fromJson(call.arguments);
        realtimeObserver?.attendeeDidLeave(attendee, didDrop: false);
        dev.log('**************************************************');
        dev.log('salgo de la conferecen');
        dev.log(attendee.toString());
        dev.log('**************************************************');

        break;
      case MethodCallOption.drop:
        final Attendee attendee = Attendee.fromJson(call.arguments);
        realtimeObserver?.attendeeDidLeave(attendee, didDrop: true);
        dev.log('**************************************************');
        dev.log('drop de la conferecen');
        dev.log(attendee.toString());
        dev.log('**************************************************');
        break;
      case MethodCallOption.mute:
        final Attendee attendee = Attendee.fromJson(call.arguments);
        realtimeObserver?.attendeeDidMute(attendee);
        dev.log('**************************************************');
        dev.log('lo pongo en mute');
        dev.log('**************************************************');
        break;
      case MethodCallOption.unmute:
        final Attendee attendee = Attendee.fromJson(call.arguments);
        realtimeObserver?.attendeeDidUnmute(attendee);
        dev.log('**************************************************');
        dev.log('lo pongo con sonido');
        dev.log('**************************************************');

        break;
      case MethodCallOption.videoTileAdd:
        final String attendeeId = call.arguments["attendeeId"];
        final VideoTile videoTile = VideoTile.fromJson(call.arguments);
        videoTileObserver?.videoTileDidAdd(attendeeId, videoTile);
        dev.log('**************************************************');
        dev.log('añado un video');
        dev.log('**************************************************');

        break;
      case MethodCallOption.videoTileRemove:
        final String attendeeId = call.arguments["attendeeId"];
        final VideoTile videoTile = VideoTile.fromJson(call.arguments);
        videoTileObserver?.videoTileDidRemove(attendeeId, videoTile);
        dev.log('**************************************************');
        dev.log('quito un video');
        dev.log('**************************************************');
        break;
      case MethodCallOption.audioSessionDidStop:
        audioVideoObserver?.audioSessionDidStop();
        dev.log('**************************************************');
        dev.log('audioSessionDidStop');
        dev.log('**************************************************');
        break;
      default:
        dev.log('**************************************************');
        dev.log(
            "Method ${call.method} with args ${call.arguments} does not exist");
        dev.log('**************************************************');
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
