import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recparenting/_shared/models/bloc_status.dart';
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
import 'package:recparenting/src/patient/bloc/patients_bloc.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/patient/ui/widgets/patients_tabbar_search.dart';
import 'package:recparenting/src/room/models/room.model.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../_shared/ui/widgets/scaffold_default.dart';
import '../../../current_user/helpers/current_user_builder.dart';
import '../widgets/patient_list_tile.widget.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  late User _currentUser;
  late final PatientsBloc _patientsBloc;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _currentUser = CurrentUserBuilder().value();
    _patientsBloc = PatientsBloc()..add(const PatientsFetch(page: 1));
    _scrollController = ScrollController()..addListener(_onListener);
  }

  void _onListener() {
    if (_scrollController.position.extentAfter < 200 &&
        !_patientsBloc.state.hasReachedMax &&
        _patientsBloc.state.blocStatus == BlocStatus.loaded) {
      _patientsBloc.add(PatientsFetch(
          page: _patientsBloc.state.page + 1,
          search: _patientsBloc.state.search));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _patientsBloc,
        child: ScaffoldDefault(
            tabBar: const PatientsTabbarSearchWidget(),
            title: AppLocalizations.of(context)!.menuPatients,
            body: BlocBuilder<PatientsBloc, PatientsState>(
                bloc: _patientsBloc,
                builder: (BuildContext context, PatientsState state) {
                  if (state.rooms.isEmpty &&
                      state.blocStatus != BlocStatus.loading) {
                    return Center(
                        child: TextDefault(
                            AppLocalizations.of(context)!.generalNoContent));
                  } else {
                    return Stack(
                      children: [
                        state.blocStatus == BlocStatus.loading
                            ? const Center(
                                child: SizedBox(
                                    height: 40,
                                    child: CircularProgressIndicator()))
                            : const SizedBox(),
                        ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(),
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            itemCount: state.rooms.length,
                            itemBuilder: (BuildContext context, int index) {
                              return getParticipantFromRoom(
                                  state.rooms[index]!);
                            })
                      ],
                    );
                  }
                })));
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
    return PatientListTile(patient: participant, room: room);
  }
}
