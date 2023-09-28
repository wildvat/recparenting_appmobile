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

  String getTitle(String title) {
    Therapist? therapist = data.therapist;
    if (therapist != null) {
      title = title.replaceAll('[therapist]', therapist.getFullName());
    } else {
      title = title.replaceAll('[therapist]', '');
    }

    DateTime? dateAppointment = data.event?.start;
    if (dateAppointment != null) {
      title = title.replaceAll('[date_appointment]',
          DateFormat.yMMMMEEEEd().format(dateAppointment).toString());
    } else {
      title = title.replaceAll('[date_appointment]', '');
    }

    DateTime? dateDisabled = data.disabledAt;
    if (dateDisabled != null) {
      title = title.replaceAll('[date_disabled]',
          DateFormat.yMMMMEEEEd().format(dateDisabled).toString());
    } else {
      title = title.replaceAll('[date_disabled]', '');
    }

    Patient? patient = data.patient;
    if (patient != null) {
      title = title.replaceAll('[patient]', patient.name);
    } else {
      title = title.replaceAll('[patient]', '');
    }

    return title;
  }

  NotificationAction? getAction() {
    NotificationAction? notificationAction;
    switch (type) {
      case NotificationType.toParticipantsWhenEventAppointmentWasCreated:
        notificationAction =
            NotificationAction(route: calendarRoute, argument: null);
        break;
      case NotificationType.toPatientWhenRequestedChange:
        break;
      case NotificationType.toPatientWhenTherapistWasAssigned:
        notificationAction = NotificationAction(
            route: therapistBioPageRoute, argument: data.therapist);
        break;
      case NotificationType.toTherapistWhenPatientWasAssigned:
        notificationAction =
            NotificationAction(route: patientShowRoute, argument: data.patient);
        break;
        case NotificationType.toParticipantsWhenForumMessageWasCreated:
        notificationAction =
            NotificationAction(route: forumsRoute, argument: null);
        break;
        case NotificationType.conversationUnreadNotification:
        notificationAction =
            NotificationAction(route: chatRoute, argument: data.room);
        break;
      default:
        notificationAction = null;
    }
    return notificationAction;
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

class NotificationAction {
  final String route;
  final dynamic argument;

  NotificationAction({required this.route, required this.argument});
}
