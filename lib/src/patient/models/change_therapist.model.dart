import 'package:recparenting/src/patient/models/change_therapist_reasons.enum.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';

class ChangeTherapist{
  late final String status;
  late final ChangeTherapistReasons reason;
  late final DateTime createdAt;
  late final Therapist? therapist;
  late final Patient? patient;

  ChangeTherapist(this.status, this.reason, this.createdAt, this.therapist, this.patient);

  ChangeTherapist.fromJson(Map<String, dynamic> json){
    status = json['status'];
    reason = convertStringFromChangeTherapistReason(json['reason']);
    createdAt = DateTime.parse(json['created_at']);
    if(json['therapist'] != null){
      therapist = Therapist.fromJson(json['therapist']);
    }
    if(json['patient'] != null){
      patient = Patient.fromJson(json['patient']);
    }
  }

}