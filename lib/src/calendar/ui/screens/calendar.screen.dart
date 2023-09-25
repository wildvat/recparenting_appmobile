import 'dart:async';

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:recparenting/src/calendar/models/event_calendar_api.model.dart';
import 'package:recparenting/src/calendar/models/events_calendar_api.model.dart';
import 'package:recparenting/src/calendar/models/type_calendar.enum.dart';
import 'package:recparenting/src/calendar/providers/calendar_provider.dart';
import 'package:recparenting/src/calendar/ui/widgets/calendar_action_buttons.dart';
import 'package:recparenting/src/calendar/ui/widgets/calendar_form_create_event.dart';
import 'package:recparenting/src/calendar/ui/widgets/calendar_header.widget.dart';
import 'package:recparenting/src/calendar/ui/widgets/event_modal_bottom_sheet.dart';
import 'package:recparenting/src/calendar/ui/widgets/month_view.widget.dart';
import 'package:recparenting/src/current_user/bloc/current_user_bloc.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';
import 'package:recparenting/src/therapist/models/working-hours.model.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with TickerProviderStateMixin {
  late final EventController _eventController = EventController();
  late final Future<EventsCalendarApiModel> _getTherapistEvents;
  late final TabController _tabController;
  late CalendarTypes _calendarType;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late final User _currentUser;
  final DateTime _now = DateTime.now();
  late DateTime _start;
  late DateTime _end;
  //bool hasReachMax = false;
  late final Future<Therapist?> _getUntilAvailableCalendar;
  //late CalendarBloc? _calendarBloc;
  DateTime? _initialDay;
  late final List<DateTime> _monthsLoaded;
  final DateTime _minMonth =
      DateTime(DateTime.now().year, DateTime.now().month, 1);
  Therapist? _therapist;
  WorkingHours _workingHours = WorkingHours.mock();

  @override
  void initState() {
    super.initState();
    _calendarType = CalendarTypes.month;
    _start = DateTime(_now.year, _now.month, 1);
    _end = DateTime(_now.year, _now.month + 1, 0);

    _monthsLoaded = [_start];
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
        _workingHours = therapist.data.working_hours;
        _therapist = therapist;
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

  _onPageChange(DateTime date, int page) async {
    final DateTime firstDayMont = DateTime(date.year, date.month, 1);
    if (!_monthsLoaded.contains(firstDayMont)) {
      _monthsLoaded.add(firstDayMont);
      EventsCalendarApiModel eventsApi = await CalendarApi().getTherapistEvents(
          therapist: _therapist!.id,
          start: DateTime(date.year, date.month, 1),
          end: DateTime(date.year, date.month + 1, 0),
          currentUser: _currentUser);
      if (eventsApi.events.events.isNotEmpty) {
        //eventController.removeWhere((element) => true);
        _eventController.addAll(eventsApi.events.events.nonNulls.toList());
      }
    }
  }

  _onDateLongPressWeekDay(DateTime date) =>
      // todo show modal with create event

      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          backgroundColor: Colors.white,
          builder: (BuildContext context) {
            return CalendarFormCreateEventWidget(
                start: date, eventController: _eventController);
          });

  _onEventsTap(List<CalendarEventData> events, DateTime date) =>
      _onEventTap(events[0], date);

  _onEventTap(CalendarEventData event, DateTime date) async {
    if (_currentUser.isPatient() &&
        (event.event as EventCalendarApiModel).user.id != _currentUser.id) {
      return;
    }
    bool? eventDeleted = await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        builder: (BuildContext context) => EventModalBottomSheet(event: event));
    if (eventDeleted != null && mounted) {
      if (eventDeleted) {
        _eventController.remove(event);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            AppLocalizations.of(context)!.eventDeleteOk,
            style: const TextStyle(color: Colors.greenAccent),
          ),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            AppLocalizations.of(context)!.eventDeleteError,
            style: const TextStyle(color: Colors.redAccent),
          ),
        ));
      }
    }
  }

  Future<Therapist?> _getUntilAvailableCalendarFn() async {
    final completer = Completer<Therapist?>();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _currentUser =
          (context.read<CurrentUserBloc>().state as CurrentUserLoaded).user;
      if (_currentUser is Patient) {
        if ((_currentUser as Patient).therapist == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              AppLocalizations.of(context)!.calendarTherapistError,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ));
          return completer.complete(null);
        }
        if ((_currentUser as Patient).subscription != 'premium') {
          Navigator.pushReplacementNamed(context, premiumRoute);
        }
      }
      Therapist? therapist;
      if (_currentUser is Therapist) {
        therapist = _currentUser as Therapist;
      } else if (_currentUser is Patient) {
        if ((_currentUser as Patient).therapist != null) {
          therapist = (_currentUser as Patient).therapist!;
        }
      }
      if (therapist != null) {
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
          if (snapshotAvailable.connectionState == ConnectionState.done) {
            if (snapshotAvailable.hasData) {
              return CalendarControllerProvider(
                key: _scaffoldKey,
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
                    actionButton: CalendarActionButtonsWidget(
                        eventController: _eventController,
                        therapist: snapshotAvailable.data!),
                    body: Builder(builder: (context) {
                      return FutureBuilder<EventsCalendarApiModel>(
                          future: _getTherapistEvents,
                          builder: (BuildContext context,
                              AsyncSnapshot<EventsCalendarApiModel>
                                  asyncSnapshotEvents) {
                            if (asyncSnapshotEvents.hasData) {
                              _eventController.addAll(asyncSnapshotEvents
                                  .data!.events.events.nonNulls
                                  .toList());
                              if (_calendarType == CalendarTypes.month) {
                                return MonthViewRec(
                                  workingHours: _workingHours,
                                  minMonth: _minMonth,
                                  onPageChange: _onPageChange,
                                  onEventTap: _onEventTap,
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
                                    minDay: _minMonth,
                                    onPageChange: _onPageChange,
                                    onEventTap: _onEventsTap,
                                    onDateLongPress: _onDateLongPressWeekDay,
                                    headerStyle: const HeaderCalendarStyle());
                              }
                              return DayView(
                                  minDay: _minMonth,
                                  onPageChange: _onPageChange,
                                  onEventTap: _onEventsTap,
                                  initialDay: _initialDay,
                                  heightPerMinute: 1,
                                  controller: _eventController,
                                  onDateLongPress: _onDateLongPressWeekDay,
                                  headerStyle: const HeaderCalendarStyle());
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          });
                    })),
              );
            }
            return ScaffoldDefault(
                body: Center(
                    child: Text(
                        AppLocalizations.of(context)!.calendarGeneralError)));
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
