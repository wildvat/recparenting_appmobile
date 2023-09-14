import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:recparenting/src/therapist/models/therapist.model.dart';

class TherapistWorkingHours extends StatelessWidget {
  final Therapist therapist;
  const TherapistWorkingHours(this.therapist, {super.key});

  @override
  Widget build(BuildContext context) {
    print(therapist.data.working_hours.toList());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.workingHoursTitle,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        ListView.builder(
            shrinkWrap: true,
            itemCount: therapist.data.working_hours.toList().length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(therapist.data.working_hours
                      .toList()[index]['day']
                      .toUpperCase()),
                ],
              );
            }),
      ],
    );
  }
}
