
/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

import 'package:flutter/material.dart';
import 'package:recparenting/src/conference/models/join_info.model.dart';
import 'package:recparenting/src/conference/models/response_enums.dart';
import '../provider/conference.provider.dart';
import 'meeting_view_model.dart';
import 'dart:io' show InternetAddress, SocketException;

import 'method_channel_coordinator.dart';

class JoinMeetingViewModel extends ChangeNotifier {
  final ConferenceApi api = ConferenceApi();

  bool loadingStatus = false;

  bool joinButtonClicked = false;

  bool error = false;
  String? errorMessage;

  bool verifyParameters(String meetingId, String attendeeName) {
    if (meetingId.isEmpty || attendeeName.isEmpty) {
      _createError(Response.empty_parameter);
      return false;
    } else if (meetingId.length < 2 || meetingId.length > 64 || attendeeName.length < 2 || attendeeName.length > 64) {
      _createError(Response.invalid_attendee_or_meeting);
      return false;
    }
    return true;
  }

  Future<bool> joinMeeting(MeetingViewModel meetingProvider, MethodChannelCoordinator methodChannelProvider, String meetingId,
      String attendeeName) async {
    print("Joining Meeting...");
    _resetError();

    bool audioPermissions = await _requestAudioPermissions(methodChannelProvider);
    bool videoPermissions = await _requestVideoPermissions(methodChannelProvider);

    // Create error messages for incorrect permissions
    if (!_checkPermissions(audioPermissions, videoPermissions)) {
      return false;
    }

    // Check if device is connected to the internet
    bool deviceIsConnected = await _isConnectedToInternet();
    if (!deviceIsConnected) {
      _createError(Response.not_connected_to_internet);
      return false;
    }

    // Make call to api and recieve info in ApiResponse format
    final JoinInfo? apiResponse = await api.join(meetingId, attendeeName);

    print("Api response...");
    // Check if ApiResponse is not null or returns a false response value indicating failed api call
    if (apiResponse == null) {
      _createError(Response.api_response_null);
      return false;
    }


    print("Set meeetingData in meetingProvider...");

    // Set meeetingData in meetingProvider
      meetingProvider.intializeMeetingData(apiResponse);


    // Convert JoinInfo object to JSON
    if (meetingProvider.meetingData == null) {
      _createError(Response.null_meeting_data);
      return false;
    }
    final Map<String, dynamic> jsonArgsToSend = api.joinInfoToJSON(meetingProvider.meetingData!);

    // Send JSON to iOS
    MethodChannelResponse? joinResponse = await methodChannelProvider.callMethod(MethodCallOption.join, jsonArgsToSend);
    print("Send JSON to iOS...");

    if (joinResponse == null) {
      _createError(Response.null_join_response);
      return false;
    }

    if (joinResponse.result) {
      print(joinResponse.arguments);
      _toggleLoadingStatus(startLoading: false);
      meetingProvider.initializeLocalAttendee();
      await meetingProvider.listAudioDevices();
      await meetingProvider.initialAudioSelection();
      return true;
    } else {
      _createError(joinResponse.arguments);
      return false;
    }
  }

  Future<bool> _requestAudioPermissions(MethodChannelCoordinator methodChannelProvider) async {
    print('pido permiso audio');
    MethodChannelResponse? audioPermission = await methodChannelProvider.callMethod(MethodCallOption.manageAudioPermissions);
    if (audioPermission == null) {
      print('pido permiso  y devulvo null');

      return false;
    }
    if (audioPermission.result) {
      print('tiene reusltado true');
      print(audioPermission.arguments);
    } else {
      print('tiene reusltado false');

      print(audioPermission.arguments);
    }
    return audioPermission.result;
  }

  Future<bool> _requestVideoPermissions(MethodChannelCoordinator methodChannelProvider) async {
    MethodChannelResponse? videoPermission = await methodChannelProvider.callMethod(MethodCallOption.manageVideoPermissions);
    if (videoPermission != null) {
      if (videoPermission.result) {
        print(videoPermission.arguments);
      } else {
        print(videoPermission.arguments);
      }
      return videoPermission.result;
    }
    return false;
  }

  bool _checkPermissions(bool audioPermissions, bool videoPermissions) {
    if (!audioPermissions && !videoPermissions) {
      _createError(Response.audio_and_video_permission_denied);
      return false;
    } else if (!audioPermissions) {
      _createError(Response.audio_not_authorized);
      return false;
    } else if (!videoPermissions) {
      _createError(Response.video_not_authorized);
      return false;
    }
    return true;
  }

  void _createError(String errorMessage) {
    error = true;
    this.errorMessage = errorMessage;
    print(errorMessage);
    _toggleLoadingStatus(startLoading: false);
    notifyListeners();
  }

  void _resetError() {
    _toggleLoadingStatus(startLoading: true);
    error = false;
    errorMessage = null;
    notifyListeners();
  }

  void _toggleLoadingStatus({required bool startLoading}) {
    loadingStatus = startLoading;
    notifyListeners();
  }

  Future<bool> _isConnectedToInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }
}
