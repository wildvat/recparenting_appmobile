import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:recparenting/_shared/models/days_week.enum.dart';
import 'package:recparenting/_shared/models/user.model.dart';

import 'package:recparenting/src/calendar/ui/widgets/calendar_header.widget.dart';
import 'package:recparenting/src/current_user/bloc/current_user_bloc.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';

class MonthViewRec extends StatefulWidget {
  final EventController eventController;
  final Therapist therapist;
  final Function(List<CalendarEventData<Object?>>, DateTime) onCellTap;
  final Function(CalendarEventData event, DateTime date) onEventTap;
  final Function(DateTime date, int page) onPageChange;
  final DateTime minMonth;

  const MonthViewRec(
      {required this.therapist,
      required this.minMonth,
      required this.eventController,
      required this.onCellTap,
      required this.onEventTap,
      required this.onPageChange,
      super.key});

  @override
  State<MonthViewRec> createState() => _MonthViewRecState();
}

class _MonthViewRecState extends State<MonthViewRec> {
  final monthKey = GlobalKey<ScaffoldState>();

  late final User _currentUser;

  @override
  void initState() {
    super.initState();

    _currentUser =
        (context.read<CurrentUserBloc>().state as CurrentUserLoaded).user;
  }

  @override
  Widget build(BuildContext context) {
    return MonthView(
      key: monthKey,
      useAvailableVerticalSpace: true,
      minMonth: widget.minMonth,
      startDay: WeekDays.monday,
      onPageChange: widget.onPageChange,
      headerStyle: const HeaderCalendarStyle(),
      onEventTap: widget.onEventTap,
      weekDayStringBuilder: (index) => AppLocalizations.of(context)!
          .getDay(DaysWeek.values[index].name)
          .toUpperCase()
          .substring(0, 3),
      onCellTap: widget.onCellTap,
      /*
        cellBuilder:
            (date, events, isToday, isInMonth) {
          return FilledCell(
            titleColor: isInMonth
                ? Colors.black
                : Colors.grey.shade500,
            date: date,
            shouldHighlight: isToday,
            backgroundColor: isInMonth
                ? Colors.white
                : Colors.grey.shade200,
            events: events,
            highlightColor: colorRec,
          );
        },
        */
    );
  }
}
