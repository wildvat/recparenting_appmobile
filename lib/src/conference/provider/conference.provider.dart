/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

import 'package:dio/dio.dart';
import 'package:recparenting/environments/env.dart';
import 'package:recparenting/src/conference/models/attendee_info.model.dart';
import 'package:recparenting/src/conference/models/meeting.model.dart';
import '../../../_shared/providers/http.dart';
import '../models/join_info.model.dart';
import 'dart:developer' as developer;

class ConferenceApi {
  final String _baseUrl = env.apiUrl;
  final AuthApiHttp _client = AuthApiHttp();

  Future<void> deleteMeeting(String meetingId) async {
    String url = "${_baseUrl}conference/$meetingId/meeting";
    await _client.dio.delete(url);
  }
  Future<List<AttendeeInfo>> listAttendees(String meetingId) async {
    developer.log('************************************* GET LIST ATTENDEES $meetingId');
    String url = "${_baseUrl}conference/$meetingId/attendees";
    List<AttendeeInfo> attendees = [];
    try {
      Response response = await _client.dio.get(url);
      if (response.statusCode! == 200) {
        if(response.data['Attendees'] != null && response.data['Attendees'].length > 0){
            for(var element in response.data['Attendees']){
              element['Attendee'] = element;
              attendees.add(AttendeeInfo.fromJson(element));
            }
        }
      }
      developer.log('TOTAL ATTENDEES ${attendees.length}');
    } catch (e) {
      developer.log("get request Failed. Status: ${e.toString()}");
    }
    return attendees;
  }

  Future<Meeting?> get(String meetingId) async {
    developer.log('************************************* GET MEETING $meetingId');
    String url = "${_baseUrl}conference/$meetingId/meeting";

    try {
      final Response response = await _client.dio.get(url);
      developer.log("STATUS MEETING: ${response.statusCode}");

      if (response.statusCode! == 200) {
        developer.log("GET - get api call successful!");
        Map<String, dynamic> infoMeetingMap = response.data;
        Meeting meetingInfo = Meeting.fromJson(infoMeetingMap);
        return meetingInfo;

        /*developer.log('RESPONSE meeting');
        developer.log(response);
        developer.log('RESPONSE attendee');
        developer.log(responseAttendee);*/
        //Map<String, dynamic> joinInfoAttendeeListMap = response.data;
        // JoinInfo joinInfo = JoinInfo.fromJson(joinInfoMeetingMap, joinInfoAttendeeMap);
      }
      return null;
    } catch (e) {
      developer.log("get request Failed. Status: ${e.toString()}");
      return null;
    }
  }

  Future<AttendeeInfo?> createAttendee(String meetingId, String userId)
  async {
    String url = "${_baseUrl}conference/$meetingId/attendee";
    try {
      //final http.Response response = await http.post(Uri.parse(url));
      Response response = await _client.dio.post(url);
      //final http.Response responseAttendee = await http.post(Uri.parse(urlAttendee));
      developer.log("STATUS CREATE ATTENDEE: ${response.statusCode}");
      if (response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        developer.log("POST - create attendee api call successful!");
        developer.log(response.data.toString());
        //Map<String, dynamic> joinInfoAttendeeMap = response.data;
        AttendeeInfo joinInfo = AttendeeInfo.fromJson(response.data);
        return joinInfo;
      }
    } catch (e) {
      developer.log("createAttendee request Failed. Status: ${e.toString()}");
      return null;
    }
    return null;
  }

  Future<JoinInfo?> join(String meetingId, String userId) async {
    developer.log('conferenceia $meetingId');
    String url = "${_baseUrl}conference/$meetingId/meeting";
    String urlAttendee = "${_baseUrl}conference/$meetingId/attendee";
    try {
      //final http.Response response = await http.post(Uri.parse(url));
      Response response = await _client.dio.post(url);
      //final http.Response responseAttendee = await http.post(Uri.parse(urlAttendee));
      Response responseAttendee = await _client.dio.post(urlAttendee);
      developer.log("STATUS MEETING: ${response.statusCode}");
      developer.log("STATUS ATTENDEE: ${responseAttendee.statusCode}");
      if (response.statusCode! >= 200 &&
          response.statusCode! < 300 &&
          responseAttendee.statusCode! >= 200 &&
          responseAttendee.statusCode! < 300) {
        developer.log("POST - join api call successful!");
        Map<String, dynamic> joinInfoMeetingMap = response.data;
        Map<String, dynamic> joinInfoAttendeeMap = responseAttendee.data;
        JoinInfo joinInfo =
            JoinInfo.fromJson(joinInfoMeetingMap, joinInfoAttendeeMap);
        return joinInfo;
      }
    } catch (e) {
      developer.log("join request Failed. Status: ${e.toString()}");
      return null;
    }
    return null;
  }

  Map<String, dynamic> joinInfoToJSON(JoinInfo info) {
    Map<String, dynamic> flattenedJSON = {
      "MeetingId": info.meeting.meetingId,
      "ExternalMeetingId": info.meeting.externalMeetingId,
      "MediaRegion": info.meeting.mediaRegion,
      "AudioHostUrl": info.meeting.mediaPlacement.audioHostUrl,
      "AudioFallbackUrl": info.meeting.mediaPlacement.audioFallbackUrl,
      "SignalingUrl": info.meeting.mediaPlacement.signalingUrl,
      "TurnControlUrl": info.meeting.mediaPlacement.turnControllerUrl,
      "ExternalUserId": info.attendee.externalUserId,
      "AttendeeId": info.attendee.attendeeId,
      "JoinToken": info.attendee.joinToken
    };

    return flattenedJSON;
  }
}

