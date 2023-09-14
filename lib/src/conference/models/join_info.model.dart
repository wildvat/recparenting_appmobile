
import 'attendee_info.model.dart';
import 'meeting.model.dart';

class JoinInfo {
  final Meeting meeting;

  final AttendeeInfo attendee;

  JoinInfo(this.meeting, this.attendee);

  factory JoinInfo.fromJson(Map<String, dynamic> jsonMeeting, Map<String, dynamic> jsonAttendee) {
    return JoinInfo(Meeting.fromJson(jsonMeeting), AttendeeInfo.fromJson(jsonAttendee));
  }
}