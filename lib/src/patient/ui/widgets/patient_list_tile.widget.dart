import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/room/models/room.model.dart';

import '../../../../_shared/helpers/avatar_image.dart';
import '../screens/patient_show.screen.dart';

class PatientListTile extends StatelessWidget {
  final Patient patient;
  final Room? room;
  final Future<dynamic>? action;

  const PatientListTile({
    required this.patient,
    super.key,
    this.room,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    Widget subtitle = const SizedBox();
    if (room != null && room?.lastMessage != null) {
      subtitle = Text(DateFormat.yMMMEd().format(room!.lastMessage!.createdAt));
    }
    return ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.transparent,
          child: AvatarImage(user: patient),
        ),
        title: Text(patient.name),
        subtitle: subtitle,
        onTap: () {

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PatientShowScreen(patient: patient)));

        });
  }
}
