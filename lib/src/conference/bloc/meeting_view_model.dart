/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:recparenting/navigator_key.dart';
import 'package:recparenting/src/conference/models/response_enums.dart';
import 'dart:developer' as dev;

import '../../current_user/bloc/current_user_bloc.dart';
import '../interfaces/attendee.dart';
import '../interfaces/audio_devices_interface.dart';
import '../interfaces/audio_video_interface.dart';
import '../interfaces/realtime_interface.dart';
import '../interfaces/video_tile.dart';
import '../interfaces/video_tile_interface.dart';
import '../models/join_info.model.dart';
import 'method_channel_coordinator.dart';

class MeetingViewModel extends ChangeNotifier
    implements
        RealtimeInterface,
        VideoTileInterface,
        AudioDevicesInterface,
        AudioVideoInterface {
  String? meetingId;

  JoinInfo? meetingData;

  MethodChannelCoordinator? methodChannelProvider;

  String? localAttendeeId;
  String? remoteAttendeeId;
  String? contentAttendeeId;

  String? selectedAudioDevice;
  List<String?> deviceList = [];

  // AttendeeId is the key
  Map<String, Attendee> currAttendees = {};

  bool isReceivingScreenShare = false;
  bool isMeetingActive = false;
  final CurrentUserBloc _currentUserBloc =
      BlocProvider.of<CurrentUserBloc>(navigatorKey.currentContext!);
  MeetingViewModel(BuildContext context) {
    methodChannelProvider =
        Provider.of<MethodChannelCoordinator>(context, listen: false);
  }

  //
  // ————————————————————————— Initializers —————————————————————————
  //

  void intializeMeetingData(JoinInfo meetData) {
    isMeetingActive = true;
    meetingData = meetData;
    meetingId = meetData.meeting.externalMeetingId;
    notifyListeners();
  }

  void initializeLocalAttendee() {
    if (meetingData == null) {
      dev.log(Response.null_meeting_data);
      return;
    }
    localAttendeeId = meetingData!.attendee.attendeeId;

    if (localAttendeeId == null) {
      dev.log(Response.null_local_attendee);
      return;
    }
    currAttendees[localAttendeeId!] =
        Attendee(localAttendeeId!, meetingData!.attendee.externalUserId);
    notifyListeners();
  }

  //
  // ————————————————————————— Interface Methods —————————————————————————
  //

  @override
  void attendeeDidJoin(Attendee attendee) {
    String? attendeeIdToAdd = attendee.attendeeId;
    if (_isAttendeeContent(attendeeIdToAdd)) {
      dev.log("Content detected");
      contentAttendeeId = attendeeIdToAdd;
      if (contentAttendeeId != null) {
        currAttendees[contentAttendeeId!] = attendee;
        dev.log("Content added to the meeting");
      }
      notifyListeners();
      return;
    }

    if (attendeeIdToAdd != localAttendeeId) {
      remoteAttendeeId = attendeeIdToAdd;
      if (remoteAttendeeId == null) {
        dev.log(Response.null_remote_attendee);
        return;
      }
      currAttendees[remoteAttendeeId!] = attendee;
      dev.log(
          "${formatExternalUserId(currAttendees[remoteAttendeeId]?.externalUserId)} has joined the meeting.");
      notifyListeners();
    }
  }

  // Used for both leave and drop callbacks
  @override
  void attendeeDidLeave(Attendee attendee, {required bool didDrop}) {
    final attIdToDelete = attendee.attendeeId;
    currAttendees.remove(attIdToDelete);
    if (didDrop) {
      dev.log(
          "${formatExternalUserId(attendee.externalUserId)} has dropped from the meeting");
    } else {
      dev.log(
          "${formatExternalUserId(attendee.externalUserId)} has left the meeting");
    }
    notifyListeners();
  }

  @override
  void attendeeDidMute(Attendee attendee) {
    _changeMuteStatus(attendee, mute: true);
  }

  @override
  void attendeeDidUnmute(Attendee attendee) {
    _changeMuteStatus(attendee, mute: false);
  }

  @override
  void videoTileDidAdd(String attendeeId, VideoTile videoTile) {
    dev.log('**************************************************');
    dev.log('videoTileDidAdd $attendeeId $videoTile');
    dev.log('**************************************************');
    currAttendees[attendeeId]?.videoTile = videoTile;
    if (videoTile.isContentShare) {
      isReceivingScreenShare = true;
      notifyListeners();
      return;
    }
    currAttendees[attendeeId]?.isVideoOn = true;
    notifyListeners();
  }

  @override
  void videoTileDidRemove(String attendeeId, VideoTile videoTile) {
    if (videoTile.isContentShare) {
      currAttendees[contentAttendeeId]?.videoTile = null;
      isReceivingScreenShare = false;
    } else {
      currAttendees[attendeeId]?.videoTile = null;
      currAttendees[attendeeId]?.isVideoOn = false;
    }
    dev.log('**************************************************');
    dev.log('videoTileDidRemove $attendeeId $videoTile');
    dev.log('**************************************************');
    notifyListeners();
  }

  @override
  Future<void> initialAudioSelection() async {
    MethodChannelResponse? device = await methodChannelProvider
        ?.callMethod(MethodCallOption.initialAudioSelection);
    if (device == null) {
      dev.log(Response.null_initial_audio_device);
      return;
    }
    dev.log("Initial audio device selection: ${device.arguments}");
    selectedAudioDevice = device.arguments;
    notifyListeners();
  }

  @override
  Future<void> listAudioDevices() async {
    MethodChannelResponse? devices = await methodChannelProvider
        ?.callMethod(MethodCallOption.listAudioDevices);

    if (devices == null) {
      dev.log(Response.null_audio_device_list);
      return;
    }
    final deviceIterable = devices.arguments.map((device) => device.toString());

    final devList = List<String?>.from(deviceIterable.toList());
    dev.log("Devices available: $devList");
    deviceList = devList;
    notifyListeners();
  }

  @override
  void updateCurrentDevice(String device) async {
    MethodChannelResponse? updateDeviceResponse = await methodChannelProvider
        ?.callMethod(MethodCallOption.updateAudioDevice, device);

    if (updateDeviceResponse == null) {
      dev.log(Response.null_audio_device_update);
      return;
    }

    if (updateDeviceResponse.result) {
      dev.log("${updateDeviceResponse.arguments} to: $device");
      selectedAudioDevice = device;
      notifyListeners();
    } else {
      dev.log("${updateDeviceResponse.arguments}");
    }
  }

  @override
  void audioSessionDidStop() {
    dev.log("Audio session stopped by AudioVideoObserver.");
    _resetMeetingValues();
  }

  //
  // —————————————————————————— Methods ——————————————————————————————————————
  //

  void _changeMuteStatus(Attendee attendee, {required bool mute}) {
    final attIdToggleMute = attendee.attendeeId;
    currAttendees[attIdToggleMute]?.muteStatus = mute;
    if (mute) {
      dev.log(
          "${formatExternalUserId(attendee.externalUserId)} has been muted");
    } else {
      dev.log(
          "${formatExternalUserId(attendee.externalUserId)} has been unmuted");
    }
    notifyListeners();
  }

  void sendLocalMuteToggle() async {
    if (!currAttendees.containsKey(localAttendeeId)) {
      dev.log("Local attendee not found");
      return;
    }

    if (currAttendees[localAttendeeId]!.muteStatus) {
      MethodChannelResponse? unmuteResponse =
          await methodChannelProvider?.callMethod(MethodCallOption.unmute);
      if (unmuteResponse == null) {
        dev.log(Response.unmute_response_null);
        return;
      }

      if (unmuteResponse.result) {
        dev.log(
            "${unmuteResponse.arguments} ${formatExternalUserId(currAttendees[localAttendeeId]?.externalUserId)}");
        notifyListeners();
      } else {
        dev.log(
            "${unmuteResponse.arguments} ${formatExternalUserId(currAttendees[localAttendeeId]?.externalUserId)}");
      }
    } else {
      MethodChannelResponse? muteResponse =
          await methodChannelProvider?.callMethod(MethodCallOption.mute);
      if (muteResponse == null) {
        dev.log(Response.mute_response_null);
        return;
      }

      if (muteResponse.result) {
        dev.log(
            "${muteResponse.arguments} ${formatExternalUserId(currAttendees[localAttendeeId]?.externalUserId)}");
        notifyListeners();
      } else {
        dev.log(
            "${muteResponse.arguments} ${formatExternalUserId(currAttendees[localAttendeeId]?.externalUserId)}");
      }
    }
  }

  void sendLocalVideoTileOn() async {
    if (!currAttendees.containsKey(localAttendeeId)) {
      dev.log("Local attendee not found");
      return;
    }

    if (currAttendees[localAttendeeId]!.isVideoOn) {
      MethodChannelResponse? videoStopped = await methodChannelProvider
          ?.callMethod(MethodCallOption.localVideoOff);
      if (videoStopped == null) {
        dev.log(Response.video_stopped_response_null);
        return;
      }

      if (videoStopped.result) {
        dev.log(videoStopped.arguments);
      } else {
        dev.log(videoStopped.arguments);
      }
    } else {
      MethodChannelResponse? videoStart = await methodChannelProvider
          ?.callMethod(MethodCallOption.localVideoOn);
      if (videoStart == null) {
        dev.log(Response.video_start_response_null);
        return;
      }

      if (videoStart.result) {
        dev.log(videoStart.arguments);
      } else {
        dev.log(videoStart.arguments);
      }
    }
  }

  void stopMeeting() async {
    MethodChannelResponse? stopResponse =
        await methodChannelProvider?.callMethod(MethodCallOption.stop);
    if (stopResponse == null) {
      dev.log(Response.stop_response_null);
      return;
    }
    dev.log(stopResponse.arguments);
  }

  //
  // —————————————————————————— Helpers ——————————————————————————————————————
  //

  void _resetMeetingValues() {
    meetingId = null;
    meetingData = null;
    localAttendeeId = null;
    remoteAttendeeId = null;
    contentAttendeeId = null;
    selectedAudioDevice = null;
    deviceList = [];
    currAttendees = {};
    isReceivingScreenShare = false;
    isMeetingActive = false;
    dev.log("Meeting values reset");
    notifyListeners();
  }

  String formatExternalUserId(String? externalUserId) {
    if (_currentUserBloc.state is CurrentUserLoaded) {
      if ((_currentUserBloc.state as CurrentUserLoaded).user.id ==
          externalUserId) {
        return (_currentUserBloc.state as CurrentUserLoaded).user.name;
      }
    }
    List<String>? externalUserIdArray = externalUserId?.split("#");
    if (externalUserIdArray == null) {
      return "UNKNOWN";
    }
    //TODO un get user a la api para asaber el nombre de la persona
    String extUserId =
        externalUserIdArray.length == 2 ? externalUserIdArray[1] : "UNKNOWN";
    return extUserId;
  }

  bool _isAttendeeContent(String? attendeeId) {
    List<String>? attendeeIdArray = attendeeId?.split("#");
    return attendeeIdArray?.length == 2;
  }
}
