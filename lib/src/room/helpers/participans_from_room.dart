import 'package:recparenting/src/room/models/room.model.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';

import '../../patient/models/patient.model.dart';

Patient? getPatientFromRoom(Room room) {
  for (var element in room.participants) {
      if (element.isPatient()) {
       return element as Patient;

    }
  }
  return null;
}
Therapist? getTherapistFromRoom(Room room) {
  for (var element in room.participants) {
      if (element.isTherapist()) {
        return element as Therapist;
      }

  }
  return null;
}