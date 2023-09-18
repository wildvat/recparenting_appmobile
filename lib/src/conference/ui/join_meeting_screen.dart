/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:recparenting/src/current_user/bloc/current_user_bloc.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';

import '../../../_shared/models/user.model.dart';
import '../provider/join_meeting_provider.dart';
import '../provider/meeting_provider.dart';
import '../provider/method_channel_coordinator.dart';
import 'meeting_screen.dart';
import 'dart:developer' as developer;

class JoinMeetingScreen extends StatefulWidget {
  final String conferenceId;
  const JoinMeetingScreen({Key? key, required this.conferenceId}) : super(key: key);

  @override
  State<JoinMeetingScreen> createState() => _JoinMeetingScreenState();
}

class _JoinMeetingScreenState extends State<JoinMeetingScreen> {


  late final CurrentUserBloc _currentUserBloc;
  late User currentUser;

  @override
  void initState() {
    super.initState();
    _currentUserBloc = context.read<CurrentUserBloc>();
    if(_currentUserBloc.state is CurrentUserLoaded){

      currentUser = (_currentUserBloc.state as CurrentUserLoaded).user;
      if(currentUser is Therapist){
        currentUser = (currentUser as Therapist);
      }
      if(currentUser is Patient){
        currentUser = (currentUser as Patient);
      }

    }
  }
  @override
  Widget build(BuildContext context) {
    final joinMeetingProvider = Provider.of<JoinMeetingProvider>(context);
    final methodChannelProvider = Provider.of<MethodChannelCoordinator>(context);
    final meetingProvider = Provider.of<MeetingProvider>(context);

    final orientation = MediaQuery.of(context).orientation;

    return joinMeetingBody(joinMeetingProvider, methodChannelProvider, meetingProvider, context, orientation);
  }

//
  Widget joinMeetingBody(JoinMeetingProvider joinMeetingProvider, MethodChannelCoordinator methodChannelProvider,
      MeetingProvider meetingProvider, BuildContext context, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      return joinMeetingBodyPortrait(joinMeetingProvider, methodChannelProvider, meetingProvider, context);
    } else {
      return joinMeetingBodyLandscape(joinMeetingProvider, methodChannelProvider, meetingProvider, context);
    }
  }

//
  Widget joinMeetingBodyPortrait(JoinMeetingProvider joinMeetingProvider, MethodChannelCoordinator methodChannelProvider,
      MeetingProvider meetingProvider, BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Conference'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            joinButton(joinMeetingProvider, methodChannelProvider, meetingProvider, context),
            loadingIcon(joinMeetingProvider),
            errorMessage(joinMeetingProvider),
          ],
        ),
      ),
    );
  }

//
  Widget joinMeetingBodyLandscape(JoinMeetingProvider joinMeetingProvider, MethodChannelCoordinator methodChannelProvider,
      MeetingProvider meetingProvider, BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 60,
              ),
              joinButton(joinMeetingProvider, methodChannelProvider, meetingProvider, context),
              loadingIcon(joinMeetingProvider),
              errorMessage(joinMeetingProvider),
            ],
          ),
        ),
      ),
    );
  }

//
  Widget joinButton(JoinMeetingProvider joinMeetingProvider, MethodChannelCoordinator methodChannelProvider,
      MeetingProvider meetingProvider, BuildContext context) {
    return ElevatedButton(
      child: const Text("Entrar"),
      onPressed: () async {
        if (!joinMeetingProvider.joinButtonClicked) {
          // Prevent multiple clicks
          joinMeetingProvider.joinButtonClicked = true;
          String meeetingId = widget.conferenceId;
          String attendeeId = '-aaaaaaaaaaaaaaaaaaaaaaaaaaaaa';

          if (joinMeetingProvider.verifyParameters(meeetingId, attendeeId)) {
            // Observers should be initialized before MethodCallHandler
            methodChannelProvider.initializeObservers(meetingProvider);
            methodChannelProvider.initializeMethodCallHandler();

            // Call api, format to JSON and send to native
            bool isMeetingJoined =
                await joinMeetingProvider.joinMeeting(meetingProvider, methodChannelProvider, meeetingId, attendeeId);
            if (isMeetingJoined) {
              // ignore: use_build_context_synchronously
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>ChangeNotifierProvider.value(
                      value: meetingProvider,
                      child: const MeetingScreen()
                  )
                  ),
              );
            }
          }
          joinMeetingProvider.joinButtonClicked = false;
        }
      },
    );
  }

  Widget loadingIcon(JoinMeetingProvider joinMeetingProvider) {
    if (joinMeetingProvider.loadingStatus) {
      return const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: CircularProgressIndicator());
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget errorMessage(JoinMeetingProvider joinMeetingProvider) {
    if (joinMeetingProvider.error) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              "${joinMeetingProvider.errorMessage}",
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
