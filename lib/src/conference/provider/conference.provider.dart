/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

import 'package:dio/dio.dart';
import 'package:recparenting/environments/env.dart';

import '../../../_shared/providers/http.dart';
import '../models/join_info.model.dart';


class ConferenceApi {
  final String _baseUrl = env.apiUrl;
  final AuthApiHttp client = AuthApiHttp();

  Future<JoinInfo?> join(String meetingId, String attendeeId) async {
    print('conferenceia $meetingId');
    String url = "${_baseUrl}conference/$meetingId/meeting";
    String urlAttendee = "${_baseUrl}conference/$meetingId/attendee";

    try {
      //final http.Response response = await http.post(Uri.parse(url));
      Response response = await client.dio.post(url);

      //final http.Response responseAttendee = await http.post(Uri.parse(urlAttendee));
      Response responseAttendee = await client.dio.post(urlAttendee);

      print("STATUS MEETING: ${response.statusCode}");
      print("STATUS ATTENDEE: ${responseAttendee.statusCode}");

      if ( response.statusCode! >= 200 && response.statusCode! < 300 && responseAttendee.statusCode! >= 200 && responseAttendee.statusCode! < 300) {

        print("POST - join api call successful!");
        /*print('RESPONSE meeting');
        print(response);
        print('RESPONSE attendee');
        print(responseAttendee);*/
        Map<String, dynamic> joinInfoMeetingMap = response.data;
        Map<String, dynamic> joinInfoAttendeeMap = responseAttendee.data;
        print('final mapeo');
        /*print('RESPONSE joinInfoAttendeeMap');
        print(joinInfoAttendeeMap);*/
        print('RESPONSE joinInfoMeetingMap');
        print(joinInfoMeetingMap['Meeting']);
        JoinInfo joinInfo = JoinInfo.fromJson(joinInfoMeetingMap, joinInfoAttendeeMap);
        return joinInfo;
      }
    } catch (e) {
      print("join request Failed. Status: ${e.toString()}");
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






class ApiResponse {
  final bool response;
  final JoinInfo? content;
  final String? error;

  ApiResponse({required this.response, this.content, this.error});
}
