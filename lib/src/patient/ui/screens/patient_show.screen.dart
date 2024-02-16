import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recparenting/_shared/helpers/avatar_image.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/models/text_sizes.enum.dart';
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
import 'package:recparenting/_shared/ui/widgets/title.widget.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/src/calendar/models/event.model.dart';
import 'package:recparenting/src/calendar/models/events.model.dart';
import 'package:recparenting/src/calendar/models/type_appointments.dart';
import 'package:recparenting/src/calendar/providers/calendar_provider.dart';
import 'package:recparenting/src/current_user/helpers/current_user_builder.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/src/patient/ui/widgets/patient_header_therapist.dart';

import '../../../../_shared/ui/widgets/button_add_calendar.dart';

class PatientShowScreen extends StatefulWidget {
  final Patient patient;

  const PatientShowScreen({super.key, required this.patient});

  @override
  PatientShowScreenState createState() => PatientShowScreenState();
}

class PatientShowScreenState extends State<PatientShowScreen> {
  late Future<EventsModel?> _calendar;
  final User _currentUser = CurrentUserBuilder().value();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    CalendarApi calendarApi = CalendarApi();
    DateTime start = DateTime(now.year, now.month, 1);
    DateTime end = DateTime(now.year, now.month + 1, 0);
    _calendar = calendarApi.getPatientEvents(
        patientId: widget.patient.id,
        start: start,
        end: end,
        currentUser: widget.patient);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
      title: AppLocalizations.of(context)!.menuRoom,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          _currentUser.isTherapist()
              ? Container(
                  height: 250,
                  decoration: const BoxDecoration(
                    color: colorRec,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: colorRecLight,
                            minRadius: 35.0,
                            child: IconButton(
                              color: Colors.white,
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, joinConferenceRoute,
                                    arguments: widget.patient.conference);
                              },
                              icon:
                                  const Icon(Icons.video_camera_front_outlined),
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: colorRecLight.shade700,
                            minRadius: 50.0,
                            child: AvatarImage(user: widget.patient, size: 90),
                          ),
                          CircleAvatar(
                            backgroundColor: colorRecLight,
                            minRadius: 35.0,
                            child: IconButton(
                              color: Colors.white,
                              onPressed: () {
                                Navigator.pushNamed(context, chatRoute,
                                    arguments: widget.patient);
                              },
                              icon: const Icon(Icons.message),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TitleDefault(widget.patient.name,
                          size: TitleSize.large, color: TextColors.white),
                    ],
                  ),
                )
              : widget.patient.therapist != null
                  ? PatientHeaderTherapist(therapist: widget.patient.therapist!)
                  : const SizedBox.shrink(),
          const SizedBox(
            height: 20,
          ),
          Padding(
              padding: const EdgeInsets.only(left: 30, bottom: 10),
              child: TitleDefault(
                AppLocalizations.of(context)!.upcomingAppointmentsTitle,
                size: TitleSize.large,
                textAlign: TextAlign.start,
              )),
          FutureBuilder<EventsModel?>(
              future: _calendar,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(color: colorRec));
                } else {
                  if (snapshot.hasData && snapshot.data.events.isNotEmpty) {
                    return Expanded(
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.total,
                            itemBuilder: (BuildContext context, int index) {
                              EventModel event = snapshot.data?.events[index];
                              return getEventListTile(event);
                            }));
                  } else {
                    return Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Center(
                            child: TextDefault(AppLocalizations.of(context)!
                                .patientNotHasEvents)));
                  }
                }
              })
        ],
      ),
    );
  }

  Widget getEventListTile(EventModel event) {
    return ListTile(
      leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.transparent,
          child: Icon(
            event.getIcon(),
            color: colorRec,
            size: 30,
          )),
      trailing: ButtonAddCalendar(event: event),
      title: TextDefault(
        DateFormat.yMMMMEEEEd().format(event.start),
        size: TextSizes.large,
      ),
      subtitle: TextDefault(
          '${DateFormat.Hm().format(event.start)} - ${DateFormat.Hm().format(event.end)}',
          color: TextColors.muted),
      onTap: () {
        if (event.type == AppointmentTypes.appointment_video) {
          Navigator.pushNamed(context, joinConferenceRoute,
              arguments: event.patient.conference);
        } else if (event.type == AppointmentTypes.appointment_chat) {
          Navigator.pushNamed(context, chatRoute, arguments: event.patient);
        }
      },
    );
  }
}
