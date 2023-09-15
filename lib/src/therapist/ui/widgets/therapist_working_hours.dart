import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/constants/colors.dart';

import 'package:recparenting/src/therapist/models/therapist.model.dart';
import 'package:recparenting/src/therapist/models/working-hours.model.dart';

class TherapistWorkingHours extends StatefulWidget {
  final Therapist therapist;
  const TherapistWorkingHours(this.therapist, {super.key});

  @override
  State<TherapistWorkingHours> createState() => _TherapistWorkingHoursState();
}

class _TherapistWorkingHoursState extends State<TherapistWorkingHours> {
  late List _workingHours;

  @override
  void initState() {
    super.initState();
    _workingHours = widget.therapist.data.working_hours.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.workingHoursTitle,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ListView.separated(
            shrinkWrap: true,
            itemCount: _workingHours.length,
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 10),
            itemBuilder: (BuildContext context, int index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .getDay(_workingHours[index]['day'])
                        .toUpperCase(),
                    style: const TextStyle(color: colorRec),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: (_workingHours[index]['startEnd']
                              as WorkingHoursStartEndList)
                          .hours
                          ?.length,
                      itemBuilder: (BuildContext context, int indexWh) {
                        return Text(
                            '${(_workingHours[index]['startEnd'] as WorkingHoursStartEndList).hours?[indexWh].start} - ${(_workingHours[index]['startEnd'] as WorkingHoursStartEndList).hours?[indexWh].end}');
                      }),
                ],
              );
            }),
      ],
    );
  }
}
