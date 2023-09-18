import 'dart:async';

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recparenting/_shared/models/days_week.enum.dart';
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:recparenting/src/calendar/models/events.model.dart';
import 'package:recparenting/src/calendar/models/type_calendar.enum.dart';
import 'package:recparenting/src/calendar/providers/calendar_provider.dart';
import 'package:recparenting/src/calendar/ui/widgets/calendar_header.widget.dart';
import 'package:recparenting/src/current_user/bloc/current_user_bloc.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final EventController _eventController = EventController();
  late CalendarTypes _calendarType;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late final User _currentUser;
  final DateTime _now = DateTime.now();
  late DateTime _start;
  late DateTime _end;
  int _page = 1;
  List<int?> pagesLoaded = [];
  //bool hasReachMax = false;
  late final Future<Therapist?> _getUntilAvailableCalendar;
  //late CalendarBloc? _calendarBloc;

  @override
  void initState() {
    super.initState();
    _calendarType = CalendarTypes.month;
    _start = DateTime(_now.year, _now.month, 1);
    _end = DateTime(_now.year, _now.month + 1, 0);
    _getUntilAvailableCalendar = _getUntilAvailableCalendarFn();
  }

  Future<Therapist?> _getUntilAvailableCalendarFn() async {
    final completer = Completer<Therapist?>();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _currentUser =
          (context.read<CurrentUserBloc>().state as CurrentUserLoaded).user;
      if (_currentUser is Patient &&
          (_currentUser as Patient).subscription != 'premium') {
        Navigator.pushReplacementNamed(context, premiumRoute);
      }
      Therapist? therapist;
      if (_currentUser is Therapist) {
        therapist = _currentUser as Therapist;
      } else if (_currentUser is Patient &&
          (_currentUser as Patient).therapist != null) {
        therapist = (_currentUser as Patient).therapist!;
      }
      if (therapist != null) {
        /*
        _calendarBloc = CalendarBloc(
            eventController: _eventController, therapistId: therapist.id)
          ..add(CalendarEventsFetch(page: 1, start: _start, end: _end));
        */
        return completer.complete(therapist);
      }
      return completer.complete(null);
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Therapist?>(
        future: _getUntilAvailableCalendar,
        builder: (BuildContext context,
            AsyncSnapshot<Therapist?> snapshotAvailable) {
          if (snapshotAvailable.hasData) {
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
                    return FutureBuilder<EventsApiModel>(
                        future: CalendarApi().getTherapistEvents(
                            therapist: snapshotAvailable.data!.id,
                            start: _start,
                            end: _end),
                        builder: (BuildContext context,
                            AsyncSnapshot<EventsApiModel> asyncSnapshotEvents) {
                          if (asyncSnapshotEvents.hasData) {
                            _eventController.addAll(asyncSnapshotEvents
                                .data!.events.events.nonNulls
                                .toList());
                            if (_calendarType == CalendarTypes.month) {
                              return MonthView(
                                  startDay: WeekDays.monday,
                                  onPageChange: (date, page) async {
                                    if (!pagesLoaded.contains(page)) {
                                      pagesLoaded.add(page);
                                      EventsApiModel eventsApi =
                                          await CalendarApi()
                                              .getTherapistEvents(
                                                  therapist:
                                                      snapshotAvailable
                                                          .data!.id,
                                                  start: DateTime(
                                                      date.year, date.month, 1),
                                                  end: DateTime(date.year,
                                                      date.month + 1, 0));
                                      if (eventsApi.events.total > 0) {
                                        /*
                                      _eventController
                                          .removeWhere((element) => true);
                                          */
                                        _eventController.addAll(eventsApi
                                            .events.events.nonNulls
                                            .toList());
                                      }
                                    }
                                  },
                                  headerStyle: const HeaderCalendarStyle(),
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
                                  onEventTap: (event, date) {
                                    showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.white,
                                        builder: (BuildContext context) =>
                                            Container(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: const Column(
                                                  children: [Text('hola')],
                                                )));
                                  },
                                  weekDayStringBuilder: (index) =>
                                      AppLocalizations.of(context)!
                                          .getDay(DaysWeek.values[index].name)
                                          .toUpperCase()
                                          .substring(0, 3),
                                  onCellTap: (events, date) => setState(
                                      () => _calendarType = CalendarTypes.day));
                            } else if (_calendarType == CalendarTypes.week) {
                              return WeekView(
                                  headerStyle: const HeaderCalendarStyle(),
                                  onEventTap: (events, date) => setState(
                                      () => _calendarType = CalendarTypes.day));
                            }
                            return const DayView(
                                headerStyle: HeaderCalendarStyle());
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        });
                  })),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
