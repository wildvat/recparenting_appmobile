import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recparenting/_shared/helpers/avatar_image.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/src/calendar/providers/calendar_provider.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import '../../../../constants/router_names.dart';
import '../../../calendar/models/events_api.model.dart';

class PatientShowScreen extends StatefulWidget {
  final Patient patient;

  const PatientShowScreen({Key? key, required this.patient}) : super(key: key);

  @override
  PatientShowScreenState createState() => PatientShowScreenState();
}

class PatientShowScreenState extends State<PatientShowScreen> {
  late Future<EventsApiModel> calendar;
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
                          print('sadf');
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
          Text('Aqui podemos poner por ejemplo las citas ${widget.patient}'),
          FutureBuilder(
          future: calendar,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox();
            } else {
              if (snapshot.hasData) {}
            }
            return SizedBox();
          })
        ],
      ),
    );
  }
}
