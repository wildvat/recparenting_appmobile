import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recparenting/_shared/helpers/avatar_image.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/src/calendar/models/event.model.dart';
import 'package:recparenting/src/calendar/models/events.model.dart';
import 'package:recparenting/src/calendar/models/type_appointments.dart';
import 'package:recparenting/src/calendar/providers/calendar_provider.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PatientShowScreen extends StatefulWidget {
  final Patient patient;

  const PatientShowScreen({Key? key, required this.patient}) : super(key: key);

  @override
  PatientShowScreenState createState() => PatientShowScreenState();
}

class PatientShowScreenState extends State<PatientShowScreen> {
  late Future<EventsModel?> calendar;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    CalendarApi calendarApi = CalendarApi();
    DateTime start = DateTime(now.year, now.month, 1);
    DateTime end = DateTime(now.year, now.month + 1, 0);
    calendar = calendarApi.getPatientEvents(patientId: widget.patient.id,
        start: start,
        end: end,
        currentUser: widget.patient);
  }

  @override
  Widget build(BuildContext context) {


    return ScaffoldDefault(
      title: widget.patient.name,
      body: Column(
        children: [
          Container(
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
                          Navigator.pushNamed(context, joinConferencePageRoute, arguments: widget.patient.conference);
                        },
                        icon: const Icon(Icons.video_camera_front_outlined),

                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: colorRecLight.shade700,
                      minRadius: 50.0,
                      child: AvatarImage(user: widget.patient),
                    ),
                    CircleAvatar(
                      backgroundColor: colorRecLight,
                      minRadius: 35.0,
                      child: IconButton(
                        color: Colors.white,
                        onPressed: () {
                          Navigator.pushNamed(context, chatPageRoute, arguments: widget.patient);
                        },
                        icon: const Icon(Icons.message),

                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.patient.name,
                  style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder<EventsModel?>(
          future: calendar,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center( child: CircularProgressIndicator(color: colorRec));
            } else {
              if (snapshot.hasData && snapshot.data.events.isNotEmpty) {
                return Expanded(child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    itemCount: snapshot.data!.total,
                    itemBuilder: (BuildContext context, int index) {
                      EventModel event = snapshot.data?.events[index];
                        return getEventListTile(event);

                    }));
              }else{
                return Text(AppLocalizations.of(context)!.patientNotHasEvents);
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
        child: Icon(event.getIcon())
      ),
      title: Text(DateFormat.yMMMMEEEEd().format(event.start)),
      subtitle: Text('${DateFormat.Hm().format(event.start)} - ${DateFormat.Hm().format(event.end)}'),

      onTap: () {
        if(event.type == AppointmentTypes.appointment_video){
          Navigator.pushNamed(context, joinConferencePageRoute,
              arguments: event.patient.conference);
        }
        /*
        Navigator.pushNamed(context, joinConferencePageRoute,
            arguments: participant!.conference);*/
      },
    );
  }

}
