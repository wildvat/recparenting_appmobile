import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:recparenting/src/calendar/ui/widgets/calendar_form_create_event.dart';
import 'package:recparenting/src/calendar/ui/widgets/legend_bottomshhet.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';
import 'package:recparenting/src/therapist/ui/widgets/therapist_working_hours.dart';

class CalendarActionButtonsWidget extends StatelessWidget {
  final Therapist therapist;
  final EventController eventController;
  const CalendarActionButtonsWidget(
      {required this.therapist, required this.eventController, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              showModalBottomSheet<void>(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) => Padding(
                      padding: const EdgeInsets.all(20),
                      child: CalendarFormCreateEventWidget(
                          eventController: eventController)));
            }),
        IconButton(
            icon: const Icon(Icons.schedule),
            onPressed: () {
              showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) => Padding(
                      padding: const EdgeInsets.all(20),
                      child: TherapistWorkingHours(therapist)));
            }),
        IconButton(
            icon: const Icon(Icons.live_help_outlined),
            onPressed: () {
              showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) =>
                      const CalendarLegendWidget());
            }),
      ],
    );
  }
}
