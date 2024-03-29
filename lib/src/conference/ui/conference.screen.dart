import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/_shared/ui/widgets/snack_bar.widget.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/src/current_user/helpers/current_user_builder.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/room/models/room.model.dart';
import 'package:recparenting/src/room/models/rooms.model.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';

import '../../../_shared/ui/widgets/scaffold_default.dart';
import '../../patient/ui/widgets/patient_list_tile.widget.dart';
import '../../room/providers/room.provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../provider/join_meeting_provider.dart';
import '../provider/meeting_provider.dart';
import '../provider/method_channel_coordinator.dart';
import 'join_meeting.screen.dart';

class ConferenceScreen extends StatefulWidget {
  const ConferenceScreen({super.key});

  @override
  State<ConferenceScreen> createState() => _ConferenceScreenState();
}

class _ConferenceScreenState extends State<ConferenceScreen> {
  late User _currentUser;
  late Future<Rooms?> _rooms;

  @override
  void initState() {
    super.initState();
    _currentUser = CurrentUserBuilder().value();

    if (_currentUser is Therapist) {
      RoomApi roomApi = RoomApi();
      _rooms = roomApi.getAll(1, 9999);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser is Patient) {
      return conferenceToPatient();
    }
    return conferenceToTherapist();
  }

  Widget conferenceToTherapist() {
    return ScaffoldDefault(
        title: AppLocalizations.of(context)!.conferenceTitle,
        body: FutureBuilder<Rooms?>(
            future: _rooms,
            builder: (BuildContext context, AsyncSnapshot<Rooms?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: SizedBox(
                        height: 40,
                        child: CircularProgressIndicator(color: colorRec)));
              }
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      itemCount: snapshot.data!.total,
                      itemBuilder: (BuildContext context, int index) {
                        Room? room = snapshot.data?.rooms[index];
                        if (room != null) {
                          return getParticipantFromRoom(room);
                        }
                        return const SizedBox();
                      });
                } else {
                  return const SizedBox();
                }
              }
              return const SizedBox();
            }));
  }

  Widget conferenceToPatient() {
    Patient patient = _currentUser as Patient;
    if (patient.conference == null) {
      SnackBarRec(
          message: AppLocalizations.of(context)!.conferenceNotAvailable);
      return const SizedBox();
    }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MethodChannelCoordinator()),
        ChangeNotifierProvider(create: (_) => JoinMeetingProvider()),
        ChangeNotifierProvider(create: (context) => MeetingProvider(context)),
      ],
      child: JoinMeetingScreen(
        conferenceId: patient.conference!,
      ),
    );
  }

  Widget getParticipantFromRoom(Room room) {
    late Patient? participant;
    for (var element in room.participants) {
      if (element.id != _currentUser.id) {
        if (element.isPatient()) {
          participant = element as Patient;
        }
      }
    }
    if (participant == null) {
      return Container();
    }
    return PatientListTile(patient: participant);
  }
}
