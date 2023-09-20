import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/src/conference/models/attendee.dart';
import 'package:recparenting/src/conference/models/attendee_info.model.dart';
import 'package:recparenting/src/conference/models/join_info.model.dart';
import 'package:recparenting/src/conference/models/meeting.model.dart';
import 'package:recparenting/src/conference/models/response_enums.dart';
import '../../../navigator_key.dart';
import '../../current_user/bloc/current_user_bloc.dart';
import 'conference.provider.dart';
import 'meeting_provider.dart';
import 'dart:io' show InternetAddress, SocketException;

import 'method_channel_coordinator.dart';
import 'dart:developer' as developer;

class JoinMeetingProvider extends ChangeNotifier {


  final ConferenceApi api = ConferenceApi();
  bool loadingStatus = false;
  bool joinButtonClicked = false;
  bool error = false;
  bool info = false;
  String? errorMessage;
  late User currentUser;
  final CurrentUserBloc _currentUserBloc = BlocProvider.of<CurrentUserBloc>(navigatorKey.currentContext!);


  JoinMeetingProvider(){
    if(_currentUserBloc.state is CurrentUserLoaded){
      if(_currentUserBloc.state is CurrentUserLoaded){
        currentUser = (_currentUserBloc.state as CurrentUserLoaded).user ;
      }
    }
  }

  bool verifyParameters(String meetingId) {

    if (meetingId.isEmpty ) {
      _createError(ResponseConference.emptyParameter);
      return false;
    } else if (meetingId.length < 2 ||
        meetingId.length > 64) {
      _createError(ResponseConference.invalidAttendeeOrMeeting);
      return false;
    }
    return true;
  }

  Future<bool> joinMeeting(MeetingProvider meetingProvider, MethodChannelCoordinator methodChannelProvider,String meetingId, String userId) async {
    _resetError();

    bool audioPermissions = await _requestAudioPermissions(methodChannelProvider);
    bool videoPermissions =         await _requestVideoPermissions(methodChannelProvider);

    // Create error messages for incorrect permissions
    if (!_checkPermissions(audioPermissions, videoPermissions)) {
      return false;
    }

    // Check if device is connected to the internet
    bool deviceIsConnected = await _isConnectedToInternet();
    if (!deviceIsConnected) {
      _createError(ResponseConference.notConnectedToInternet);
      return false;
    }

    late AttendeeInfo? currentAttendee;
    late Meeting? meetingInfo;

    Meeting? meetingResponse = await api.get(meetingId);
    if (meetingResponse != null) {
      //Si existe meeting creo el attendee
      meetingInfo = meetingResponse;
      currentAttendee = await api.createAttendee(meetingId, userId);
      //Si no puedo crear el attendee salgo
      if(currentAttendee == null){
        _createError(ResponseConference.apiResponseNull);
        return false;
      }
      /*
      Busco el listado de usuarios que estan en el meeting y loas añado a la conferencia
       */
      final List<AttendeeInfo> apiListAttendeesResponse = await api.listAttendees(meetingId);
      if (apiListAttendeesResponse.isNotEmpty) {
        for (var attendee in apiListAttendeesResponse) {
          if (attendee.attendeeId != currentAttendee.attendeeId) {
            meetingProvider.attendeeDidJoin(Attendee(attendee.attendeeId, attendee.externalUserId));
          }
        }
      }

    } else {
      //Si no existe el meeting y soy paciente, salgo porque no lo puedo crear, tengo que esperar a que se conecte el terapeuta
      if(currentUser != null && currentUser.isPatient()){
        _createInfo(ResponseConference.userPatientNotPermission);
        return false;
      }
      //Si soy terapeita creo el meeting
      final JoinInfo? apiResponse = await api.join(meetingId, userId);
      if (apiResponse != null) {
        meetingInfo = apiResponse.meeting;
        currentAttendee = apiResponse.attendee;
      } else {
        _createError(ResponseConference.apiResponseNull);
        return false;
      }
    }


    //Si no existe el meeting o el attendee salgo
    if (meetingInfo == null || currentAttendee == null) {
      _createError(ResponseConference.apiResponseNull);
      return false;
    }

    //Hago el  Join al meeting
    JoinInfo joinInfo = JoinInfo(meetingInfo, currentAttendee);
    meetingProvider.intializeMeetingData(joinInfo);

    // Convert JoinInfo object to JSON
    if (meetingProvider.meetingData == null) {
      _createError(ResponseConference.nullMeetingData);
      return false;
    }
    final Map<String, dynamic> jsonArgsToSend =
        api.joinInfoToJSON(meetingProvider.meetingData!);

    // Send JSON to iOS
    MethodChannelResponse? joinResponse = await methodChannelProvider
        .callMethod(MethodCallOption.join, jsonArgsToSend);
    developer.log("Send JSON to iOS...");

    if (joinResponse == null) {
      _createError(ResponseConference.nullJoinResponse);
      return false;
    }

    if (joinResponse.result) {
      developer.log(joinResponse.arguments);
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

  Future<bool> _requestAudioPermissions(
      MethodChannelCoordinator methodChannelProvider) async {
    MethodChannelResponse? audioPermission = await methodChannelProvider
        .callMethod(MethodCallOption.manageAudioPermissions);
    if (audioPermission == null) {
      return false;
    }
    if (audioPermission.result) {
      print(audioPermission.arguments);
    } else {
      print(audioPermission.arguments);
    }
    return audioPermission.result;
  }

  Future<bool> _requestVideoPermissions(
      MethodChannelCoordinator methodChannelProvider) async {
    MethodChannelResponse? videoPermission = await methodChannelProvider
        .callMethod(MethodCallOption.manageVideoPermissions);
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
      _createError(ResponseConference.audioAndVideoPermissionDenied);
      return false;
    } else if (!audioPermissions) {
      _createError(ResponseConference.audioNotAuthorized);
      return false;
    } else if (!videoPermissions) {
      _createError(ResponseConference.videoNotAuthorized);
      return false;
    }
    return true;
  }

  void _createError(String errorMessage) {
    error = true;
    this.errorMessage = errorMessage;
    developer.log(errorMessage);
    _toggleLoadingStatus(startLoading: false);
    notifyListeners();
  }
  void _createInfo(String infoMessage) {
    info = true;
    errorMessage = infoMessage;
    developer.log(infoMessage);
    _toggleLoadingStatus(startLoading: false);
    notifyListeners();
  }
  void _resetError() {
    _toggleLoadingStatus(startLoading: true);
    error = false;
    info = false;
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
