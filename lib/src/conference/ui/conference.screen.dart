import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:recparenting/_shared/helpers/avatar_image.dart';
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/src/current_user/bloc/current_user_bloc.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/room/models/room.model.dart';
import 'package:recparenting/src/room/models/rooms.model.dart';

import '../../room/providers/room.provider.dart';
import '../provider/join_meeting_provider.dart';
import '../provider/meeting_provider.dart';
import '../provider/method_channel_coordinator.dart';
import 'join_meeting_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConferenceScreen extends StatefulWidget {
  const ConferenceScreen({Key? key}) : super(key: key);

  @override
  State<ConferenceScreen> createState() => _ConferenceScreenState();
}

class _ConferenceScreenState extends State<ConferenceScreen> {
  late CurrentUserBloc _currentUserBloc;
  late User currentUser;

  @override
  void initState() {
    super.initState();
    _currentUserBloc = context.read<CurrentUserBloc>();
    if (_currentUserBloc.state is CurrentUserLoaded) {
      currentUser = (_currentUserBloc.state as CurrentUserLoaded).user;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser is Patient) {
      Patient patient = currentUser as Patient;
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => MethodChannelCoordinator()),
          ChangeNotifierProvider(create: (_) => JoinMeetingProvider()),
          ChangeNotifierProvider(create: (context) => MeetingProvider(context)),
        ],
        child: JoinMeetingScreen(
          conferenceId: patient.conference,
        ),
      );
    }
    RoomApi roomApi = RoomApi();
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.conferenceTitle),
        ),
        body: FutureBuilder<Rooms?>(
            future: roomApi.getAll(1, 9999),
            builder:
                (BuildContext context, AsyncSnapshot<Rooms?> snapshot) {
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

  Widget getParticipantFromRoom(Room room) {
    late Patient? participant;
    for (var element in room.participants) {
      if (element.id != currentUser.id) {
        if(element.isPatient()){
          participant = element as Patient;
        }
      }
    }
    if(participant == null) {
      return Container();
    }
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.transparent,
        child: AvatarImage(user:participant),
      ),
      title: Text(participant.name),
      subtitle: (room.lastMessage != null)? Text(DateFormat.yMMMEd().format(room.lastMessage!.createdAt)): const SizedBox(),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MultiProvider(
                      providers: [
                        ChangeNotifierProvider(
                            create: (_) => MethodChannelCoordinator()),
                        ChangeNotifierProvider(
                            create: (_) => JoinMeetingProvider()),
                        ChangeNotifierProvider(
                            create: (context) => MeetingProvider(context)),
                      ],
                      child: JoinMeetingScreen(
                        conferenceId: participant!.conference,
                      ),
                    )));
      },
    );
  }

}
