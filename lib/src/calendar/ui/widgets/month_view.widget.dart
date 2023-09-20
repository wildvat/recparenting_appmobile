import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:recparenting/_shared/models/days_week.enum.dart';
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/src/calendar/models/event_api.model.dart';
import 'package:recparenting/src/calendar/models/events_api.model.dart';
import 'package:recparenting/src/calendar/providers/calendar_provider.dart';

import 'package:recparenting/src/calendar/ui/widgets/calendar_header.widget.dart';
import 'package:recparenting/src/current_user/bloc/current_user_bloc.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';

class MonthViewRec extends StatefulWidget {
  late EventController eventController;
  late Therapist therapist;
  late Function(List<CalendarEventData<Object?>>, DateTime) onCellTap;

  MonthViewRec(
      {required this.therapist,
      required this.eventController,
      required this.onCellTap,
      super.key});

  @override
  State<MonthViewRec> createState() => _MonthViewRecState();
}

class _MonthViewRecState extends State<MonthViewRec> {
  late final List<int> _pagesLoaded;
  final DateTime _minMonth = DateTime(2022);

  final monthKey = GlobalKey<ScaffoldState>();

  late final User _currentUser;
  late final int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = _minMonth.getMonthDifference(DateTime.now()) - 1;

    _pagesLoaded = [_currentPage];
    _currentUser =
        (context.read<CurrentUserBloc>().state as CurrentUserLoaded).user;
  }

  @override
  Widget build(BuildContext context) {
    return MonthView(
        key: monthKey,
        minMonth: _minMonth,
        startDay: WeekDays.monday,
        onPageChange: (date, page) async {
          if (!_pagesLoaded.contains(page)) {
            _pagesLoaded.add(page);
            EventsApiModel eventsApi = await CalendarApi().getTherapistEvents(
                therapist: widget.therapist.id,
                start: DateTime(date.year, date.month, 1),
                end: DateTime(date.year, date.month + 1, 0),
                currentUser: _currentUser);
            if (eventsApi.events.total > 0) {
              //eventController.removeWhere((element) => true);
              widget.eventController
                  .addAll(eventsApi.events.events.nonNulls.toList());
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
          if (_currentUser.isPatient() &&
              (event.event as EventApiModel).user.id != _currentUser.id) {
            return;
          }
          final EventApiModel eventApi = event.event as EventApiModel;
          print(event.startTime.toString());
          print(event.endTime.toString());
          showModalBottomSheet(
              context: context,
              backgroundColor: Colors.white,
              builder: (BuildContext context) => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(event.title,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Container(
                          decoration: BoxDecoration(
                            color: event.color,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          child: Text(AppLocalizations.of(context)!
                              .eventType(eventApi.type)
                              .toUpperCase())),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Text('Desde:',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 5),
                              Text(event.startTime.toString().substring(
                                  0, event.startTime.toString().length - 7)),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Hasta:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 5),
                              Text(event.endTime.toString().substring(
                                  0, event.endTime.toString().length - 7))
                            ],
                          )
                        ],
                      )
                    ],
                  )));
        },
        weekDayStringBuilder: (index) => AppLocalizations.of(context)!
            .getDay(DaysWeek.values[index].name)
            .toUpperCase()
            .substring(0, 3),
        onCellTap: widget.onCellTap);
  }
}
