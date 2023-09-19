/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/navigator_key.dart';

// ignore_for_file: ant_identifier_names

class ResponseConference {
  static String audioAndVideoPermissionDenied = AppLocalizations.of(navigatorKey.currentContext!)?.permissionAudioVideoDenied ?? ' ERROR audio and video permissions denied.';
  static String audioNotAuthorized = AppLocalizations.of(navigatorKey.currentContext!)?.permissionAudioNotAuthorized ?? "ERROR audio permissions not authorized.";
  static String videoNotAuthorized = AppLocalizations.of(navigatorKey.currentContext!)?.permissionVideoNotAuthorized ?? "ERROR video permissions not authorized.";

  // API
  static  String notConnectedToInternet = AppLocalizations.of(navigatorKey.currentContext!)?.notConnectedInternet ??"ERROR device is not connected to the internet.";
  static  String apiResponseNull = "ERROR api response is null";
  static  String apiCallFailed = "ERROR api call has returned incorrect status";

  // Meeting
  static  String emptyParameter = "ERROR empty meeting or attendee";
  static  String invalidAttendeeOrMeeting = "ERROR meeting or attendee are too short or long.";
  static  String nullJoinResponse = "ERROR join response is null.";
  static  String nullMeetingData = "ERROR meeting data is null";
  static  String nullLocalAttendee = "ERROR local attendee is null";
  static  String nullRemoteAttendee = "ERROR remote attendee is null";
  static  String stopResponseNull = "ERROR stop response is null";
  static  String userPatientNotPermission = "Esperando a que se conecte el terapeuta";

  // Observers
  static  String nullRealtimeObservers = "WARNING realtime observer is null";
  static  String nullAudioVideoObservers = "WARNING audiovideo observer is null";
  static  String nullVideotileObservers = "WARNING videotile observer is null";

  // Mute
  static  String muteResponseNull = "ERROR mute response is null.";
  static  String unmuteResponseNull = "ERROR unmute response is null.";

  // Video
  static  String videoStartResponseNull = "ERROR video start response is null";
  static  String videoStoppedResponseNull = "ERROR video stop response is null";

  // Audio Device
  static  String nullInitialAudioDevice = "ERROR failed to get initial audio device";
  static  String nullAudioDeviceList = "ERROR audio device list is null";
  static  String nullAudioDeviceUpdate = "ERROR audio device update is null.";
}

class MethodCallOption {
  static  const String manageAudioPermissions = "manageAudioPermissions";
  static  const String manageVideoPermissions = "manageVideoPermissions";
  static  const String initialAudioSelection = "initialAudioSelection";
  static  const String join = "join";
  static  const String stop = "stop";
  static  const String leave = "leave";
  static  const String drop = "drop";
  static  const String mute = "mute";
  static  const String unmute = "unmute";
  static  const String localVideoOn = "startLocalVideo";
  static  const String localVideoOff = "stopLocalVideo";
  static  const String videoTileAdd = "videoTileAdd";
  static  const String videoTileRemove = "videoTileRemove";
  static  const String listAudioDevices = "listAudioDevices";
  static  const String updateAudioDevice = "updateAudioDevice";
  static  const String audioSessionDidDrop = "audioSessionDidDrop";
  static  const String audioSessionDidStop = "audioSessionDidStop";
}
