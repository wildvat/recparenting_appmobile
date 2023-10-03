import 'package:flutter/material.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';

class BottomAppBarPatient extends StatelessWidget {
  final Patient patient;

  const BottomAppBarPatient({
    required this.patient,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 60,
      padding: const EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 0),
      color: colorRecDark,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
              color: Colors.white,
              disabledColor: Colors.white54,
              icon: const Icon(
                Icons.video_camera_front_outlined,
                size: 30,
              ),
              onPressed: patient.therapist == null
                  ? null
                  : () =>
                      Navigator.pushReplacementNamed(context, conferenceRoute)),
          IconButton(
              color: Colors.white,
              disabledColor: Colors.white54,
              icon: const Icon(
                Icons.badge_outlined,
                size: 30,
              ),
              onPressed: patient.therapist == null
                  ? null
                  : () => Navigator.pushReplacementNamed(
                      context, therapistBioPageRoute,
                      arguments: patient.therapist)),
          const SizedBox(width: 50),
          IconButton(
              color: Colors.white,
              icon: const Icon(
                Icons.calendar_month_outlined,
                size: 30,
              ),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, calendarRoute)),
          IconButton(
            color: Colors.white,
            disabledColor: Colors.white54,
            icon: const Icon(
              Icons.add_task_outlined,
              size: 30,
            ),
            onPressed:
                patient.therapist == null || patient.subscription != 'premium'
                    ? null
                    : () => Navigator.pushReplacementNamed(
                        context, patientShowRoute,
                        arguments: patient),
          ),
        ],
      ),
    );
  }
}
