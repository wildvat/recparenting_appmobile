import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/src/calendar/models/events_color.enum.dart';
import 'package:recparenting/src/calendar/models/type_appointments.dart';

class CalendarLegendWidget extends StatelessWidget {
  const CalendarLegendWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.calendarHelpDayWeek),
            const SizedBox(height: 10),
            Text(AppLocalizations.of(context)!.calendarHelpColors),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: AppointmentTypes.values.length,
                itemBuilder: ((BuildContext context, int index) {
                  return ListTile(
                    leading: Text(
                      AppLocalizations.of(context)!
                          .eventType(AppointmentTypes.values[index]
                              .toString()
                              .replaceAll('AppointmentTypes.', ''))
                          .toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    tileColor: calendarEventsColors[AppointmentTypes
                        .values[index]
                        .toString()
                        .replaceAll('AppointmentTypes.', '')],
                  );
                }))
          ],
        ));
  }
}
