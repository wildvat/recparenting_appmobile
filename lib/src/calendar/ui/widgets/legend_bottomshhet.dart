import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:recparenting/_shared/models/text_sizes.enum.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
import 'package:recparenting/src/calendar/models/events_color.enum.dart';
import 'package:recparenting/src/calendar/models/type_appointments.dart';

class CalendarLegendWidget extends StatelessWidget {
  const CalendarLegendWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextDefault(AppLocalizations.of(context)!.calendarHelpDayWeek),
            const SizedBox(height: 30),
            TextDefault(
              AppLocalizations.of(context)!.calendarHelpColors,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 10),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: AppointmentTypes.values.length,
                itemBuilder: ((BuildContext context, int index) {
                  return ListTile(
                    title: TextDefault(
                      AppLocalizations.of(context)!
                          .eventType(AppointmentTypes.values[index]
                              .toString()
                              .replaceAll('AppointmentTypes.', ''))
                          .capitalize(),
                      fontWeight: FontWeight.bold,
                      size: TextSizes.large,
                      textAlign: TextAlign.center,
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
