import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/src/current_user/bloc/current_user_bloc.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';

import '../provider/join_meeting_provider.dart';
import '../provider/meeting_provider.dart';
import '../provider/method_channel_coordinator.dart';
import 'join_meeting_screen.dart';


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
    if(_currentUserBloc.state is CurrentUserLoaded){
      currentUser = (_currentUserBloc.state as CurrentUserLoaded).user;
    }
  }

  @override
  Widget build(BuildContext context) {
    if(currentUser is Patient) {
      Patient patient = currentUser as Patient;
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => MethodChannelCoordinator()),
          ChangeNotifierProvider(create: (_) => JoinMeetingProvider()),
          ChangeNotifierProvider(create: (context) => MeetingProvider(context)),
        ],
        child:JoinMeetingScreen(conferenceId: patient.conference,),
      );
    }
    return Text('necesitamos mostrar una lista de pacientes y redirigin a  JoinMeetingView con el valro de conferenceId');

  }
}