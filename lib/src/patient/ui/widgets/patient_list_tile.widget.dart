import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/models/text_sizes.enum.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/room/models/room.model.dart';

import '../../../../_shared/helpers/avatar_image.dart';

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
      subtitle = TextDefault(
          DateFormat.yMMMEd().format(room!.lastMessage!.createdAt),
          color: TextColors.muted,
          size: TextSizes.small);
    }
    return ListTile(
        onTap: () =>
            Navigator.pushNamed(context, patientShowRoute, arguments: patient),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.transparent,
          child: AvatarImage(user: patient),
        ),
        title: TextDefault(
          patient.name,
          fontWeight: FontWeight.bold,
          color: TextColors.rec,
        ),
        subtitle: subtitle,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, joinConferenceRoute,
                      arguments: patient.conference);
                },
                icon: const Icon(
                  Icons.video_camera_front_outlined,
                  color: colorRec,
                  size: 30,
                )),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, chatRoute, arguments: patient);
                },
                icon: const Icon(
                  Icons.message,
                  color: colorRec,
                  size: 30,
                )),
          ],
        ));
  }
}
