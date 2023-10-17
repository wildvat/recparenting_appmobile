import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/_shared/models/text_sizes.enum.dart';
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
import 'package:recparenting/src/calendar/models/events_color.enum.dart';
import 'package:recparenting/src/calendar/models/type_appointments.dart';
import 'package:recparenting/src/current_user/bloc/current_user_bloc.dart';

class CalendarLegendWidget extends StatefulWidget {
  const CalendarLegendWidget({super.key});

  @override
  State<CalendarLegendWidget> createState() => _CalendarLegendWidgetState();
}

class _CalendarLegendWidgetState extends State<CalendarLegendWidget> {
  late User _currentUser;
  late List<AppointmentTypes> _appointmentsTypes;

  @override
  void initState() {
    super.initState();
    _currentUser =
        (context.read<CurrentUserBloc>().state as CurrentUserLoaded).user;
    if (_currentUser.isTherapist()) {
      _appointmentsTypes = AppointmentTypes.values;
    } else {
      _appointmentsTypes = [
        AppointmentTypes.appointment_chat,
        AppointmentTypes.appointment_video,
        AppointmentTypes.not_available
      ];
    }
  }

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
                itemCount: _appointmentsTypes.length,
                itemBuilder: ((BuildContext context, int index) {
                  return ListTile(
                    title: TextDefault(
                      AppLocalizations.of(context)!
                          .eventType(_appointmentsTypes[index].name)
                          .toUpperCase(),
                      fontWeight: FontWeight.bold,
                      size: TextSizes.large,
                      textAlign: TextAlign.center,
                    ),
                    tileColor:
                        calendarEventsColors[_appointmentsTypes[index].name],
                  );
                }))
          ],
        ));
  }
}
