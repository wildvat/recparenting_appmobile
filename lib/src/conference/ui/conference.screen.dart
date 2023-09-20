import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:recparenting/_shared/helpers/avatar_image.dart';
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:recparenting/src/current_user/bloc/current_user_bloc.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/room/models/room.model.dart';
import 'package:recparenting/src/room/models/rooms.model.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';

import '../../../_shared/ui/widgets/scaffold_default.dart';
import '../../room/providers/room.provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConferenceScreen extends StatefulWidget {
  const ConferenceScreen({Key? key}) : super(key: key);

  @override
  State<ConferenceScreen> createState() => _ConferenceScreenState();
}

class _ConferenceScreenState extends State<ConferenceScreen> {
  late CurrentUserBloc _currentUserBloc;
  late User currentUser;
  late Future<Rooms?> rooms;

  @override
  void initState() {
    super.initState();
    _currentUserBloc = context.read<CurrentUserBloc>();
    if (_currentUserBloc.state is CurrentUserLoaded) {
      currentUser = (_currentUserBloc.state as CurrentUserLoaded).user;
      if(currentUser is Therapist){
        RoomApi roomApi = RoomApi();
        rooms =roomApi.getAll(1, 9999);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser is Patient) {
      Patient patient = currentUser as Patient;
      Navigator.pushNamed(context, joinConferencePageRoute,
          arguments: patient.conference);

    }
    return ScaffoldDefault(
        title: AppLocalizations.of(context)!.conferenceTitle,
        body: FutureBuilder<Rooms?>(
            future: rooms,
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

  Widget getParticipantFromRoom(Room room) {
    late Patient? participant;
    for (var element in room.participants) {
      if (element.id != currentUser.id) {
        if (element.isPatient()) {
          participant = element as Patient;
        }
      }
    }
    if (participant == null) {
      return Container();
    }
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.transparent,
        child: AvatarImage(user: participant),
      ),
      title: Text(participant.name),
      subtitle: (room.lastMessage != null)
          ? Text(DateFormat.yMMMEd().format(room.lastMessage!.createdAt))
          : const SizedBox(),
      onTap: () {
        Navigator.pushNamed(context, joinConferencePageRoute,
            arguments: participant!.conference);
      },
    );
  }
}
