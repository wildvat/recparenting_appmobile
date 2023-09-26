/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:recparenting/_shared/providers/user.provider.dart';
import 'package:recparenting/navigator_key.dart';
import 'package:recparenting/src/conference/models/response_enums.dart';
import 'package:recparenting/src/conference/provider/conference.provider.dart';

import '../../../_shared/models/user.model.dart';
import '../../current_user/bloc/current_user_bloc.dart';
import '../models/attendee.dart';
import '../interfaces/audio_devices_interface.dart';
import '../interfaces/audio_video_interface.dart';
import '../interfaces/realtime_interface.dart';
import '../models/video_tile.dart';
import '../interfaces/video_tile_interface.dart';
import '../models/join_info.model.dart';
import 'method_channel_coordinator.dart';
import 'dart:developer' as developer;

class MeetingProvider extends ChangeNotifier
    implements RealtimeInterface, VideoTileInterface, AudioDevicesInterface, AudioVideoInterface {
  String? _meetingId;

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
   final CurrentUserBloc _currentUserBloc = BlocProvider.of<CurrentUserBloc>(navigatorKey.currentContext!);
  MeetingProvider(BuildContext context) {
    methodChannelProvider = Provider.of<MethodChannelCoordinator>(context, listen: false);
  }

  //
  // ————————————————————————— Initializers —————————————————————————
  //

  void intializeMeetingData(JoinInfo meetData) {
    developer.log('***********************INITIALIZE MEETING DATA**********************************');

    isMeetingActive = true;
    meetingData = meetData;
    _meetingId = meetData.meeting.externalMeetingId;
    notifyListeners();
  }

  void initializeLocalAttendee() {
    developer.log('***********************INITIALIZE LOCAL ATTENDEE**********************************');
    if (meetingData == null) {
      developer.log('**************************************************');
      developer.log('nicializo local attendee');
      developer.log(ResponseConference.nullMeetingData);
      developer.log('**************************************************');

      return;
    }
    localAttendeeId = meetingData!.attendee.attendeeId;

    if (localAttendeeId == null) {
      developer.log('**************************************************');
      developer.log(ResponseConference.nullLocalAttendee);
      developer.log('local attendee es null');
      developer.log('**************************************************');

      return;
    }
    developer.log('*****************AÑADO localAttendeeId*********************************');
    developer.log('localAttendeeId $localAttendeeId');
    developer.log('externalUserId ${meetingData!.attendee.externalUserId}');
    developer.log('**************************************************');
    currAttendees[localAttendeeId!] = Attendee(localAttendeeId!, meetingData!.attendee.externalUserId);
    notifyListeners();
  }

  //
  // ————————————————————————— Interface Methods —————————————————————————
  //

  @override
  void attendeeDidJoin(Attendee attendee) {
    developer.log('***********************ATTENDEE JOINED**********************************');
    String? attendeeIdToAdd = attendee.attendeeId;
    if (attendeeIdToAdd != localAttendeeId) {
      remoteAttendeeId = attendeeIdToAdd;
      if (remoteAttendeeId == null) {
        developer.log('**************************************************');
        developer.log('********REMOVE ATENNDEE NULL**************************');
        developer.log(ResponseConference.nullRemoteAttendee);
        return;
      }
      currAttendees[remoteAttendeeId!] = attendee;
      developer.log("${formatExternalUserId(currAttendees[remoteAttendeeId]?.externalUserId)} has joined the meeting.");
      notifyListeners();
    }
  }

  // Used for both leave and drop callbacks
  @override
  void attendeeDidLeave(Attendee attendee, {required bool didDrop}) {
    developer.log('***********************ATTENDEE DID LEAVE**********************************');

    final attIdToDelete = attendee.attendeeId;
    currAttendees.remove(attIdToDelete);
    if (didDrop) {
      developer.log("${formatExternalUserId(attendee.externalUserId)} has dropped from the meeting");
    } else {
      developer.log("${formatExternalUserId(attendee.externalUserId)} has left the meeting");
    }
    notifyListeners();
  }

  @override
  void attendeeDidMute(Attendee attendee) {
    developer.log('***********************ATTENDEE DID MUTE**********************************');

    _changeMuteStatus(attendee, mute: true);
  }

  @override
  void attendeeDidUnmute(Attendee attendee) {
    developer.log('***********************ATTENDEE DID UNMUTE**********************************');

    _changeMuteStatus(attendee, mute: false);
  }

  @override
  void videoTileDidAdd(String attendeeId, VideoTile videoTile) {
    developer.log('***********************VIDEO TILE DID ADD**********************************');

    developer.log('**************************************************');
    developer.log('videoTileDidAdd $attendeeId $videoTile');
    developer.log('**************************************************');
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
    developer.log('***********************VIDEO TILE DID REMOVE**********************************');

    if (videoTile.isContentShare) {
      currAttendees[contentAttendeeId]?.videoTile = null;
      isReceivingScreenShare = false;
    } else {
      currAttendees[attendeeId]?.videoTile = null;
      currAttendees[attendeeId]?.isVideoOn = false;
    }
    developer.log('**************************************************');
    developer.log('videoTileDidRemove $attendeeId $videoTile');
    developer.log('**************************************************');
    notifyListeners();
  }

  @override
  Future<void> initialAudioSelection() async {
    developer.log('***********************INITIALIZE AUDIO SELECTION**********************************');

    MethodChannelResponse? device = await methodChannelProvider?.callMethod(MethodCallOption.initialAudioSelection);
    if (device == null) {
      developer.log(ResponseConference.nullInitialAudioDevice);
      return;
    }
    developer.log("Initial audio device selection: ${device.arguments}");
    selectedAudioDevice = device.arguments;
    notifyListeners();
  }

  @override
  Future<void> listAudioDevices() async {
    developer.log('***********************LIST AUDIO DEVICES**********************************');

    MethodChannelResponse? devices = await methodChannelProvider?.callMethod(MethodCallOption.listAudioDevices);

    if (devices == null) {
      developer.log(ResponseConference.nullAudioDeviceList);
      return;
    }
    final deviceIterable = devices.arguments.map((device) => device.toString());

    final devList = List<String?>.from(deviceIterable.toList());
    developer.log("Devices available: $devList");
    deviceList = devList;
    notifyListeners();
  }

  @override
  void updateCurrentDevice(String device) async {

    developer.log('***********************UPDATE CURRENT DEVICE**********************************');

    MethodChannelResponse? updateDeviceResponse =
        await methodChannelProvider?.callMethod(MethodCallOption.updateAudioDevice, device);

    if (updateDeviceResponse == null) {
      developer.log(ResponseConference.nullAudioDeviceUpdate);
      return;
    }

    if (updateDeviceResponse.result) {
      developer.log("${updateDeviceResponse.arguments} to: $device");
      selectedAudioDevice = device;
      notifyListeners();
    } else {
      developer.log("${updateDeviceResponse.arguments}");
    }
  }

  @override
  void audioSessionDidStop() {
    developer.log("Audio session stopped by AudioVideoObserver.");
    _resetMeetingValues();
  }

  //
  // —————————————————————————— Methods ——————————————————————————————————————
  //

  void _changeMuteStatus(Attendee attendee, {required bool mute}) {
    developer.log('***********************CHANGE MUTE STATUS**********************************');

    final attIdToggleMute = attendee.attendeeId;
    currAttendees[attIdToggleMute]?.muteStatus = mute;
    if (mute) {
      developer.log("${formatExternalUserId(attendee.externalUserId)} has been muted");
    } else {
      developer.log("${formatExternalUserId(attendee.externalUserId)} has been unmuted");
    }
    notifyListeners();
  }

  void sendLocalMuteToggle() async {
    developer.log('***********************SEND LOCAL MUTE TOOGLE**********************************');

    if (!currAttendees.containsKey(localAttendeeId)) {
      developer.log("Local attendee not found");
      return;
    }

    if (currAttendees[localAttendeeId]!.muteStatus) {
      MethodChannelResponse? unmuteResponse = await methodChannelProvider?.callMethod(MethodCallOption.unmute);
      if (unmuteResponse == null) {
        developer.log(ResponseConference.unmuteResponseNull);
        return;
      }

      if (unmuteResponse.result) {
        developer.log("${unmuteResponse.arguments} ${formatExternalUserId(currAttendees[localAttendeeId]?.externalUserId)}");
        notifyListeners();
      } else {
        developer.log("${unmuteResponse.arguments} ${formatExternalUserId(currAttendees[localAttendeeId]?.externalUserId)}");
      }
    } else {
      MethodChannelResponse? muteResponse = await methodChannelProvider?.callMethod(MethodCallOption.mute);
      if (muteResponse == null) {
        developer.log(ResponseConference.muteResponseNull);
        return;
      }

      if (muteResponse.result) {
        developer.log("${muteResponse.arguments} ${formatExternalUserId(currAttendees[localAttendeeId]?.externalUserId)}");
        notifyListeners();
      } else {
        developer.log("${muteResponse.arguments} ${formatExternalUserId(currAttendees[localAttendeeId]?.externalUserId)}");
      }
    }
  }

  void sendLocalVideoTileOn() async {
    developer.log('***********************SEND LOCAL VIDEO TILE ON**********************************');

    if (!currAttendees.containsKey(localAttendeeId)) {
      developer.log("Local attendee not found");
      return;
    }

    if (currAttendees[localAttendeeId]!.isVideoOn) {
      MethodChannelResponse? videoStopped = await methodChannelProvider?.callMethod(MethodCallOption.localVideoOff);
      if (videoStopped == null) {
        developer.log(ResponseConference.videoStoppedResponseNull);
        return;
      }

      if (videoStopped.result) {
        developer.log(videoStopped.arguments);
      } else {
        developer.log(videoStopped.arguments);
      }
    } else {
      MethodChannelResponse? videoStart = await methodChannelProvider?.callMethod(MethodCallOption.localVideoOn);
      if (videoStart == null) {
        developer.log(ResponseConference.videoStartResponseNull);
        return;
      }

      if (videoStart.result) {
        developer.log(videoStart.arguments);
      } else {
        developer.log(videoStart.arguments);
      }
    }
  }

  void stopMeeting() async {
    developer.log('***********************STOP MEETING**********************************');
    MethodChannelResponse? stopResponse = await methodChannelProvider?.callMethod(MethodCallOption.stop);
    if (stopResponse == null) {
      developer.log(ResponseConference.stopResponseNull);
      return;
    }
    ConferenceApi().deleteMeeting(_meetingId!);
    developer.log(stopResponse.arguments);
  }

  //
  // —————————————————————————— Helpers ——————————————————————————————————————
  //

  void _resetMeetingValues() {
    developer.log('***********************RESET MEETING VALUES**********************************');
    _meetingId = null;
    meetingData = null;
    localAttendeeId = null;
    remoteAttendeeId = null;
    contentAttendeeId = null;
    selectedAudioDevice = null;
    deviceList = [];
    currAttendees = {};
    isReceivingScreenShare = false;
    isMeetingActive = false;
    developer.log("Meeting values reset");
    notifyListeners();
  }

  Future<String> formatExternalUserId(String? externalUserId) async {
    developer.log('***********************FORMAT EXTERNAL USER ID**********************************');
    if(_currentUserBloc.state is CurrentUserLoaded){

        if((_currentUserBloc.state as CurrentUserLoaded).user.id == externalUserId){
          return (_currentUserBloc.state as CurrentUserLoaded).user.name ;
      }
    }

    final User? extUser;
    extUser = await UserApi().getUserById(externalUserId!);
    if(extUser != null){
      if(extUser.isTherapist()){
        return extUser.name;
      }
    }

    return 'UNKNOWN';
  }
}
