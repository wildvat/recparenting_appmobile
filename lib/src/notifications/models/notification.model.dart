import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/room/models/message.model.dart';
import 'package:recparenting/src/room/models/room.model.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';

import '../../calendar/models/event.model.dart';

class NotificationRec{
  late final String id;
  late final String type;
  late final int notifiableId;
  late final String notifiableType;
  late final NotificationData data;
  late final DateTime createdAt;

  NotificationRec({required this.id, required this.type, required this.notifiableId, required this.notifiableType, required this.data, required this.createdAt});

  NotificationRec.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    notifiableId = json['notifiable_id'];
    notifiableType = json['notifiable_type'];
    data = NotificationData.fromJson(json['data']);
    createdAt = DateTime.parse(json['created_at']);
  }


}

class NotificationData{
  final DateTime? disabledAt;
  final Patient? patient;
  final Therapist? therapist;
  final EventModel? event;
  final String? reason;
  final Message? message;
  final Room? room;

  NotificationData({this.disabledAt, this.patient, this.therapist, this.event, this.reason, this.message, this.room});

  NotificationData.fromJson(Map<String, dynamic> json) :
    disabledAt = json['disabled_at'] != null ? DateTime.parse(json['disabled_at']) : null,
    patient = json['patient'] != null ? Patient.fromJson(json['patient']) : null,
    therapist = json['therapist'] != null ? Therapist.fromJson(json['therapist']) : null,
    event = json['event'] != null ? EventModel.fromJson(json['event']) : null,
    reason = json['reason'],
    message = json['message'] != null ? Message.fromJson(json['message']) : null,
    room = json['room'] != null ? Room.fromJson(json['room']) : null;

}