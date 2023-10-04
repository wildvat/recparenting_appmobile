import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:recparenting/src/calendar/models/event_calendar_api.model.dart';
import 'package:recparenting/src/calendar/providers/calendar_provider.dart';
import 'package:recparenting/src/current_user/bloc/current_user_bloc.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';

class EventModalBottomSheet extends StatefulWidget {
  final CalendarEventData event;
  const EventModalBottomSheet({required this.event, super.key});

  @override
  State<EventModalBottomSheet> createState() => _EventModalBottomSheetState();
}

class _EventModalBottomSheetState extends State<EventModalBottomSheet> {
  late final User _currentUser;
  late final EventCalendarApiModel _eventApi;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _eventApi = widget.event.event as EventCalendarApiModel;
    _currentUser =
        (context.read<CurrentUserBloc>().state as CurrentUserLoaded).user;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextDefault(widget.event.title, fontWeight: FontWeight.bold),
            Container(
                decoration: BoxDecoration(
                  color: widget.event.color,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.only(top: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: TextDefault(AppLocalizations.of(context)!
                    .eventType(
                        (widget.event.event! as EventCalendarApiModel).type)
                    .toUpperCase())),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    TextDefault(AppLocalizations.of(context)!.eventFrom,
                        fontWeight: FontWeight.bold),
                    const SizedBox(width: 5),
                    TextDefault(widget.event.startTime.toString().substring(
                        0, widget.event.startTime.toString().length - 7)),
                  ],
                ),
                Row(
                  children: [
                    TextDefault(
                      AppLocalizations.of(context)!.eventTo,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(width: 5),
                    TextDefault(widget.event.endTime.toString().substring(
                        0, widget.event.endTime.toString().length - 7))
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    late final Patient patient;
                    if (_currentUser.isPatient()) {
                      patient = _currentUser as Patient;
                    } else {
                      patient = _eventApi.user as Patient;
                    }
                    if (_eventApi.type.contains('appointment_chat')) {
                      Navigator.pushNamed(context, chatRoute,
                          arguments: patient);
                    } else if (_eventApi.type.contains('appointment_video')) {
                      //todo enviar room o paciente....
                      Navigator.pushNamed(context, joinConferenceRoute,
                          arguments: patient.conference);
                    }
                  },
                  child: TextDefault(
                      AppLocalizations.of(context)!.eventGoSessionBtn),
                ),

                /// only tehrapist or my owns events can be visible in modal
                /// then not need to check if visible here
                ElevatedButton(
                    onPressed: () async {
                      setState(() => _loading = true);
                      bool response =
                          await CalendarApi().deleteEvent(_eventApi.id);
                      setState(() => _loading = false);
                      if (response && mounted) {
                        Navigator.pop(context, response);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: TextColors.danger.color),
                    child: _loading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : TextDefault(
                            AppLocalizations.of(context)!.generalButtonDelete,
                          ))
              ],
            )
          ],
        ));
  }
}
