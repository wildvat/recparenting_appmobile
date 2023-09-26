import 'package:flutter/material.dart';
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/room/models/room.model.dart';
import 'package:recparenting/src/room/models/rooms.model.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../_shared/ui/widgets/scaffold_default.dart';
import '../../../current_user/helpers/current_user_builder.dart';
import '../../../room/providers/room.provider.dart';
import '../widgets/patient_list_tile.widget.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({Key? key}) : super(key: key);

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  late User _currentUser;
  late Future<Rooms?> _rooms;



  @override
  void initState() {
    super.initState();
    _currentUser = CurrentUserBuilder().value();
    RoomApi roomApi = RoomApi();
    _rooms =roomApi.getAll(1, 9999);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
        title: AppLocalizations.of(context)!.menuPatients,
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
    return PatientListTile(
      patient: participant,
      room: room
    );
  }
}
