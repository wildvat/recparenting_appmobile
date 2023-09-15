import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:recparenting/_shared/models/days_week.enum.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/src/calendar/models/type_calendar.enum.dart';
import 'package:recparenting/src/calendar/ui/widgets/calendar_header.widget.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final EventController _eventController;
  late CalendarTypes _calendarType;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _eventController = EventController();
    _calendarType = CalendarTypes.month;
  }

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      key: scaffoldKey,
      controller: _eventController,
      child: ScaffoldDefault(
          title: AppLocalizations.of(context)!.calendarTitle,
          actionButton: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.calendar_month),
                onPressed: () =>
                    setState(() => _calendarType = CalendarTypes.month),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_view_week),
                onPressed: () =>
                    setState(() => _calendarType = CalendarTypes.week),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_view_day),
                onPressed: () =>
                    setState(() => _calendarType = CalendarTypes.day),
              ),
            ],
          ),
          body: Builder(builder: (context) {
            if (_calendarType == CalendarTypes.month) {
              return MonthView(
                  headerStyle: const HeaderCalendarStyle(),
                  cellBuilder: (date, events, isToday, isInMonth) {
                    final bool actualMonth =
                        date.getMonthDifference(DateTime.now()) < 2
                            ? true
                            : false;
                    // Provide your custom widget
                    return FilledCell(
                      titleColor:
                          actualMonth ? Colors.black : Colors.grey.shade500,
                      date: date,
                      shouldHighlight: isToday,
                      backgroundColor:
                          actualMonth ? Colors.white : Colors.grey.shade200,
                      events: const [],
                      highlightColor: colorRec,
                    );
                  },
                  weekDayStringBuilder: (index) => AppLocalizations.of(context)!
                      .getDay(DaysWeek.values[index].name)
                      .toUpperCase()
                      .substring(0, 3),
                  onCellTap: (events, date) =>
                      setState(() => _calendarType = CalendarTypes.day));
            } else if (_calendarType == CalendarTypes.week) {
              return WeekView(
                  headerStyle: const HeaderCalendarStyle(),
                  onEventTap: (events, date) =>
                      setState(() => _calendarType = CalendarTypes.day));
            }
            return const DayView(headerStyle: HeaderCalendarStyle());
          })),
    );
  }
}
