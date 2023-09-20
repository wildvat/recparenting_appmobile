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
            icon: const Icon(
              Icons.video_camera_front_outlined,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, conferenceRoute),
          ),
          IconButton(
            icon: const Icon(
              Icons.badge_outlined,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, therapistBioPageRoute),
          ),
          const SizedBox(width: 50),
          IconButton(
            icon: Icon(
              Icons.calendar_month_outlined,
              color: patient.subscription == 'premium'
                  ? Colors.white
                  : Colors.white54,
              size: 30,
            ),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, calendarRoute),
          ),
          IconButton(
            icon: const Icon(
              Icons.add_task_outlined,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
