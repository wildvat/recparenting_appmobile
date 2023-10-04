import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:intl/intl.dart';
import 'package:recparenting/_shared/models/days_week.enum.dart';
import 'package:recparenting/constants/colors.dart';

import 'package:recparenting/src/calendar/ui/widgets/calendar_header.widget.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';
import 'package:recparenting/src/therapist/models/working-hours.model.dart';

class MonthViewRec extends StatefulWidget {
  final EventController eventController;
  final Therapist therapist;
  final Function(List<CalendarEventData<Object?>>, DateTime) onCellTap;
  final Function(CalendarEventData event, DateTime date) onEventTap;
  final Function(DateTime date, int page) onPageChange;
  final DateTime minMonth;
  final WorkingHours workingHours;

  const MonthViewRec(
      {required this.therapist,
      required this.workingHours,
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

  @override
  void initState() {
    super.initState();
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
      cellBuilder: (date, events, isToday, isInMonth) {
        final String dayName = DateFormat('EEEE').format(date).toLowerCase();
        Color color = Colors.grey.shade200;
        for (var whour in widget.workingHours.toList()) {
          if (whour['day'] == dayName) {
            color = Colors.white;
            break;
          }
        }
        return FilledCell(
          titleColor: isInMonth ? Colors.black : Colors.grey.shade500,
          date: date,
          highlightColor: colorRec,
          shouldHighlight: isToday,
          backgroundColor: (!isInMonth) ? Colors.grey.shade200 : color,
          events: events,
          onTileTap: widget.onEventTap,
        );
      },
    );
  }
}
