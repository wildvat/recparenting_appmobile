import 'package:recparenting/src/room/models/message.model.dart';

import '../../../_shared/models/user.model.dart';
import '../../patient/models/patient.model.dart';
import '../../therapist/models/therapist.model.dart';

class Room {
  late String id;
  late bool hasPermissionToWrite;
  late Message? lastMessage;
  late List<User> participants;
  late bool isActive;
  late bool isRead;

  Room(this.id, this.hasPermissionToWrite, this.lastMessage, this.participants,
      this.isActive, this.isRead);

  Room.fromJson(Map<String, dynamic> json){

    id = json['uuid'];
    hasPermissionToWrite = json['has_permission_to_write'];
    lastMessage = json['last_message'] != null
        ? Message.fromJson(json['last_message'])
        : null;

    participants = List<User>.from(json['participants'].map((user) {

      User userf = User.fromJson(user);
      if(userf.isPatient()){
        return Patient.fromJson(user);
      }else if(userf.isTherapist()){
        return Therapist.fromJson(user);
      }
      print('MAP USER $userf  ${userf.name}');
      return userf;

    }));

    if(json['status'] == 'open'){
      isActive = true;
    }else{
      isActive = false;
    }
    isRead = json['is_read'];
  }


}