/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */


import 'package:recparenting/src/conference/interfaces/video_tile.dart';

class Attendee {
  final String attendeeId;
  final String externalUserId;

  bool muteStatus = false;
  bool isVideoOn = false;

  VideoTile? videoTile;

  Attendee(this.attendeeId, this.externalUserId);

  factory Attendee.fromJson(dynamic json) {
    print('**************************************************');
    print('attendie $json');
    print('**************************************************');

    return Attendee(json["attendeeId"], json["externalUserId"]);
  }
}
