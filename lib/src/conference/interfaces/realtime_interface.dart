/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */


import '../models/attendee.dart';
import 'dart:developer' as developer;

class RealtimeInterface {
  void attendeeDidJoin(Attendee attendee) {
    // Gets called when an attendee joins the meeting
    developer.log('**************************************************');
    developer.log('************ attendeeDidJoin Realtime Interface *************');
    developer.log('**************************************************');
  }

  void attendeeDidLeave(Attendee attendee, {required bool didDrop}) {
    // Gets called when an attendee leaves or drops the meeting
    developer.log('**************************************************');
    developer.log('************ attendeeDidLeave Realtime Interface *************');
    developer.log('**************************************************');
  }

  void attendeeDidMute(Attendee attendee) {
    // Gets called when an mutes themselvessdf
    developer.log('**************************************************');
    developer.log('************ attendeeDidMute Realtime Interface *************');
    developer.log('**************************************************');
  }

  void attendeeDidUnmute(Attendee attendee) {
    // Gets called when an unmutes themselves
    developer.log('**************************************************');
    developer.log('************ attendeeDidUnmute Realtime Interface *************');
    developer.log('**************************************************');
  }
}
