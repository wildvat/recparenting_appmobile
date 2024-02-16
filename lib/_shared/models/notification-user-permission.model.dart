class NotificationUserPermission {
  late final bool chat;
  late final bool marketing;
  late final bool forum;

  NotificationUserPermission(this.chat, this.marketing, this.forum);

  NotificationUserPermission.fromJson(Map<String, dynamic> json) {
    chat = json['chat'];
    marketing = json['marketing'];
    forum = json['forum'];
  }
  toJson(){
    return {
      'chat': chat,
      'marketing': marketing,
      'forum': forum
    };
  }
}
