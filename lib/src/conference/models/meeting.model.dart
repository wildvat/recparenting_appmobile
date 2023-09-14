class Meeting {
  final String meetingId;
  final String externalMeetingId;
  final String mediaRegion;
  final MediaPlacement mediaPlacement;

  Meeting(this.meetingId, this.externalMeetingId, this.mediaRegion, this.mediaPlacement);

  factory Meeting.fromJson(Map<String, dynamic> json) {
    // TODO zmauricv: Look into JSON Serialization Solutions
    var meetingMap = json['Meeting'];
    return Meeting(
      meetingMap['MeetingId'],
      meetingMap['ExternalMeetingId'],
      meetingMap['MediaRegion'],
      MediaPlacement.fromJson(json),
    );
  }
}

class MediaPlacement {
  final String audioHostUrl;
  final String audioFallbackUrl;
  final String signalingUrl;
  final String turnControllerUrl;

  MediaPlacement(this.audioHostUrl, this.audioFallbackUrl, this.signalingUrl, this.turnControllerUrl);

  factory MediaPlacement.fromJson(Map<String, dynamic> json) {
    var mediaPlacementMap = json['Meeting']['MediaPlacement'];
    return MediaPlacement(mediaPlacementMap['AudioHostUrl'], mediaPlacementMap['AudioFallbackUrl'],
        mediaPlacementMap['SignalingUrl'], mediaPlacementMap['TurnControlUrl']);
  }
}
