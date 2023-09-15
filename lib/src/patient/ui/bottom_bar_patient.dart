import 'package:flutter/material.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/constants/router_names.dart';

class BottomAppBarPatient extends StatefulWidget {
  const BottomAppBarPatient({
    super.key,
  });

  @override
  State<BottomAppBarPatient> createState() => _BottomAppBarPatientState();
}

class _BottomAppBarPatientState extends State<BottomAppBarPatient> {
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
                Navigator.popAndPushNamed(context, conferenceRoute),
          ),
          IconButton(
            icon: const Icon(
              Icons.badge_outlined,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () =>
                Navigator.popAndPushNamed(context, therapistBioPageRoute),
          ),
          const SizedBox(width: 50),
          IconButton(
            icon: const Icon(
              Icons.calendar_month_outlined,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () => Navigator.popAndPushNamed(context, calendarRoute),
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
