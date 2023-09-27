import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/room/models/message.model.dart';
import 'package:recparenting/src/room/models/room.model.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';

import '../../calendar/models/event.model.dart';
import '../../calendar/models/type_appointments.dart';
import 'notification_type.enum.dart';

class NotificationRec {
  late final String id;
  late final NotificationType type;
  late final int notifiableId;
  late final String notifiableType;
  late final NotificationData data;
  late final DateTime createdAt;

  NotificationRec(
      {required this.id,
      required this.type,
      required this.notifiableId,
      required this.notifiableType,
      required this.data,
      required this.createdAt});

  NotificationRec.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = convertNotificationTypeFromString(json['type']);
    notifiableId = json['notifiable_id'];
    notifiableType = json['notifiable_type'];
    data = NotificationData.fromJson(json['data']);
    createdAt = DateTime.parse(json['created_at']).toLocal();
  }

  String getTitle(String title){

    Therapist? therapist = data.therapist;
    if(therapist != null){
      title = title.replaceAll('[therapist]', therapist.getFullName());
    }

    DateTime? dateAppointment = data.event?.start;
    if(dateAppointment != null){
      title = title.replaceAll('[date_appointment]', DateFormat.yMMMMEEEEd().format(dateAppointment).toString());
    }

    return title;
  }
  List<dynamic> getAction() {
    String action = calendarRoute;
    dynamic argument = '';
    switch (type) {
      case NotificationType.toParticipantsWhenEventAppointmentWasCreated:
        action = calendarRoute;
        break;
      case NotificationType.toPatientWhenRequestedChange:
        action = calendarRoute;
        break;
      case NotificationType.toPatientWhenTherapistWasAssigned:
        action = therapistBioPageRoute;
        argument = data.therapist!;
        break;

      default:
      action = calendarRoute;
    }
    return [action, argument];
  }

  IconData getIcon() {
    IconData icon = Icons.notifications;
    switch (type) {
      case NotificationType.toParticipantsWhenEventAppointmentWasCreated:
        if (data.event!.type == AppointmentTypes.appointment_video) {
          icon = Icons.video_camera_front;
        }
        if (data.event!.type == AppointmentTypes.appointment_chat) {
          icon = Icons.chat;
        }
      case NotificationType.toPatientWhenRequestedChange:
        icon = Icons.badge_outlined;
        break;
      case NotificationType.toPatientWhenTherapistWasAssigned:
        icon = Icons.badge;
        break;
      default:
        icon = Icons.notifications;
    }
    return icon;
  }
}

class NotificationData {
  final DateTime? disabledAt;
  final Patient? patient;
  final Therapist? therapist;
  final EventModel? event;
  final String? reason;
  final Message? message;
  final Room? room;

  NotificationData(
      {this.disabledAt,
      this.patient,
      this.therapist,
      this.event,
      this.reason,
      this.message,
      this.room});

  NotificationData.fromJson(Map<String, dynamic> json)
      : disabledAt = json['disabled_at'] != null
            ? DateTime.parse(json['disabled_at']).toLocal()
            : null,
        patient =
            json['patient'] != null ? Patient.fromJson(json['patient']) : null,
        therapist = json['therapist'] != null
            ? Therapist.fromJson(json['therapist'])
            : null,
        event =
            json['event'] != null ? EventModel.fromJson(json['event']) : null,
        reason = json['reason'],
        message =
            json['message'] != null ? Message.fromJson(json['message']) : null,
        room = json['room'] != null ? Room.fromJson(json['room']) : null;
}
