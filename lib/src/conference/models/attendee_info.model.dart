import 'dart:developer' as developer;

class AttendeeInfo {
  final String externalUserId;
  final String attendeeId;
  final String joinToken;

  AttendeeInfo(this.externalUserId, this.attendeeId, this.joinToken);

  factory AttendeeInfo.fromJson(Map<String, dynamic> json) {
    var attendeeMap = json['Attendee'];
    return AttendeeInfo(attendeeMap['ExternalUserId'], attendeeMap['AttendeeId'], attendeeMap['JoinToken']);
  }

  @override
  String toString() {
    developer.log('Attendee info: $externalUserId $attendeeId $joinToken |' );
    return super.toString();
  }
}