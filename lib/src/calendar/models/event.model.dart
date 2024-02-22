import 'package:flutter/material.dart';
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/src/calendar/models/type_appointments.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';

import 'events_color.enum.dart';

class EventModel {
  final String id;
  final String modelType;
  final String modelId;
  final String title;
  final String? description;
  final AppointmentTypes type;
  final DateTime start;
  final DateTime end;
  final User user;
  final Patient? patient;
  final Therapist? therapist;

  EventModel(this.id, this.modelType, this.modelId, this.title,
      this.description, this.type, this.start, this.end, this.user,
      {this.patient, this.therapist});

  IconData getIcon() {
    late IconData icon;
    switch (type) {
      case AppointmentTypes.appointment_video:
        {
          icon = Icons.video_camera_front_outlined;
          break;
        }
      case AppointmentTypes.appointment_chat:
        {
          icon = Icons.message;
          break;
        }
      case AppointmentTypes.availability:
        {
          icon = Icons.event_available;
          break;
        }
      case AppointmentTypes.basic:
        {
          icon = Icons.api;
          break;
        }
      case AppointmentTypes.not_available:
        {
          icon = Icons.ac_unit;
          break;
        }
      default:
        {
          icon = Icons.ac_unit;
          break;
        }
    }
    return icon;
  }

  Color getColor() {
    return calendarEventsColors[type.toString()] ?? Colors.grey;
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    AppointmentTypes appointmentType = AppointmentTypes.basic;
    switch (json['type']) {
      case 'appointment_chat':
        appointmentType = AppointmentTypes.appointment_chat;
        break;
      case 'appointment_video':
        appointmentType = AppointmentTypes.appointment_video;
        break;
      case 'availability':
        appointmentType = AppointmentTypes.availability;
        break;
      case 'not_available':
        appointmentType = AppointmentTypes.not_available;
        break;
      default:
        appointmentType = AppointmentTypes.basic;
        break;
    }
    EventModel event = EventModel(
        json["uuid"],
        json["model_type"],
        json["model_id"],
        json["title"],
        json["description"],
        appointmentType,
        DateTime.parse(json["start"]).toLocal(),
        DateTime.parse(json["end"]).toLocal(),
        User.fromJson(json["user"]),
        patient:
            json["patient"] != null ? Patient.fromJson(json["patient"]) : null,
        therapist: json["therapist"] != null
            ? Therapist.fromJson(json["therapist"])
            : null);
    return event;
  }
}
