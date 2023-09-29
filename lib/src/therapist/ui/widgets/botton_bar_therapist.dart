import 'package:flutter/material.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';

class BottomAppBarTherapist extends StatelessWidget {
  final Therapist therapist;
  const BottomAppBarTherapist({
    required this.therapist,
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.post_add,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, forumsRoute)),
          IconButton(
            icon: const Icon(
              Icons.calendar_month_outlined,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, calendarRoute),
          ),
          const SizedBox(width: 50),
          IconButton(
            icon: const Icon(
              Icons.subscriptions,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, masterclassRoute),
          ),
          IconButton(
            icon: const Icon(
              Icons.podcasts,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, podcastsRoute),
          ),
        ],
      ),
    );
  }
}
