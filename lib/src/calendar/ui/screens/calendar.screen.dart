import 'dart:async';

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:recparenting/src/calendar/models/events_api.model.dart';
import 'package:recparenting/src/calendar/models/type_calendar.enum.dart';
import 'package:recparenting/src/calendar/providers/calendar_provider.dart';
import 'package:recparenting/src/calendar/ui/widgets/calendar_header.widget.dart';
import 'package:recparenting/src/calendar/ui/widgets/legend_bottomshhet.dart';
import 'package:recparenting/src/calendar/ui/widgets/month_view.widget.dart';
import 'package:recparenting/src/current_user/bloc/current_user_bloc.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with TickerProviderStateMixin {
  late final EventController _eventController = EventController();
  late final Future<EventsApiModel> _getTherapistEvents;
  late final TabController _tabController;
  late CalendarTypes _calendarType;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late final User _currentUser;
  final DateTime _now = DateTime.now();
  late DateTime _start;
  late DateTime _end;
  //bool hasReachMax = false;
  late final Future<Therapist?> _getUntilAvailableCalendar;
  //late CalendarBloc? _calendarBloc;
  bool _currentUserIsPatient = false;
  DateTime? _initialDay;

  @override
  void initState() {
    super.initState();
    _calendarType = CalendarTypes.month;
    _start = DateTime(_now.year, _now.month, 1);
    _end = DateTime(_now.year, _now.month + 1, 0);
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(() {
        if (!_tabController.indexIsChanging) {
          setState(() {
            if (_tabController.index == 0) {
              _calendarType = CalendarTypes.month;
            } else if (_tabController.index == 1) {
              _calendarType = CalendarTypes.week;
            } else {
              _calendarType = CalendarTypes.day;
            }
          });
        }
      });
    _getUntilAvailableCalendar =
        _getUntilAvailableCalendarFn().then((therapist) {
      if (therapist != null) {
        _getTherapistEvents = CalendarApi().getTherapistEvents(
            therapist: therapist.id,
            start: _start,
            end: _end,
            currentUser: _currentUser);
        return therapist;
      }
      return null;
    });
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
      } else if (_currentUser is Patient) {
        _currentUserIsPatient = true;
        if ((_currentUser as Patient).therapist != null) {
          therapist = (_currentUser as Patient).therapist!;
        }
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
  void dispose() {
    _tabController.dispose();
    _eventController.dispose();
    super.dispose();
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
                  tabBar: TabBar(
                    controller: _tabController,
                    tabs: const <Widget>[
                      Tab(
                        icon: Icon(Icons.calendar_month),
                      ),
                      Tab(
                        icon: Icon(Icons.calendar_view_week),
                      ),
                      Tab(
                        icon: Icon(Icons.calendar_view_day),
                      ),
                    ],
                  ),
                  actionButton: IconButton(
                      icon: const Icon(Icons.info_outline),
                      onPressed: () {
                        showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) =>
                                const CalendarLegendWidget());
                      }),
                  /*
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
                  */

                  body: Builder(builder: (context) {
                    return FutureBuilder<EventsApiModel>(
                        future: _getTherapistEvents,
                        builder: (BuildContext context,
                            AsyncSnapshot<EventsApiModel> asyncSnapshotEvents) {
                          if (asyncSnapshotEvents.hasData) {
                            _eventController.addAll(asyncSnapshotEvents
                                .data!.events.events.nonNulls
                                .toList());
                            if (_calendarType == CalendarTypes.month) {
                              return MonthViewRec(
                                onCellTap: (events, date) {
                                  setState(() {
                                    _initialDay = date;
                                    _tabController.index = 2;
                                  });
                                },
                                eventController: _eventController,
                                therapist: snapshotAvailable.data!,
                              );
                            } else if (_calendarType == CalendarTypes.week) {
                              return WeekView(
                                  headerStyle: const HeaderCalendarStyle(),
                                  onEventTap: (events, date) => setState(() {
                                        _initialDay = date;
                                        _calendarType = CalendarTypes.day;
                                      }));
                            }
                            return DayView(
                                initialDay: _initialDay,
                                controller: _eventController,
                                headerStyle: const HeaderCalendarStyle());
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
