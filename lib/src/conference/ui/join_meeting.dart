/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:recparenting/src/current_user/bloc/current_user_bloc.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';

import '../../../_shared/models/user.model.dart';
import '../bloc/join_meeting_view_model.dart';
import '../bloc/meeting_view_model.dart';
import '../bloc/method_channel_coordinator.dart';
import 'meeting.dart';

class JoinMeetingView extends StatefulWidget {
  final String conferenceId;
  const JoinMeetingView({Key? key, required this.conferenceId})
      : super(key: key);

  @override
  State<JoinMeetingView> createState() => _JoinMeetingViewState();
}

class _JoinMeetingViewState extends State<JoinMeetingView> {
  late final CurrentUserBloc _currentUserBloc;
  late User currentUser;

  @override
  void initState() {
    super.initState();
    _currentUserBloc = context.read<CurrentUserBloc>();
    if (_currentUserBloc.state is CurrentUserLoaded) {
      currentUser = (_currentUserBloc.state as CurrentUserLoaded).user;
      if (currentUser is Therapist) {
        currentUser = (currentUser as Therapist);
      }
      if (currentUser is Patient) {
        currentUser = (currentUser as Patient);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final joinMeetingProvider = Provider.of<JoinMeetingViewModel>(context);
    final methodChannelProvider =
        Provider.of<MethodChannelCoordinator>(context);
    final meetingProvider = Provider.of<MeetingViewModel>(context);

    final orientation = MediaQuery.of(context).orientation;

    return joinMeetingBody(joinMeetingProvider, methodChannelProvider,
        meetingProvider, context, orientation);
  }

//
  Widget joinMeetingBody(
      JoinMeetingViewModel joinMeetingProvider,
      MethodChannelCoordinator methodChannelProvider,
      MeetingViewModel meetingProvider,
      BuildContext context,
      Orientation orientation) {
    if (orientation == Orientation.portrait) {
      return joinMeetingBodyPortrait(
          joinMeetingProvider, methodChannelProvider, meetingProvider, context);
    } else {
      return joinMeetingBodyLandscape(
          joinMeetingProvider, methodChannelProvider, meetingProvider, context);
    }
  }

//
  Widget joinMeetingBodyPortrait(
      JoinMeetingViewModel joinMeetingProvider,
      MethodChannelCoordinator methodChannelProvider,
      MeetingViewModel meetingProvider,
      BuildContext context) {
    return ScaffoldDefault(
      title: 'One to One VIDEO',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            titleFlutterDemo(5),
            joinButton(joinMeetingProvider, methodChannelProvider,
                meetingProvider, context),
            loadingIcon(joinMeetingProvider),
            errorMessage(joinMeetingProvider),
          ],
        ),
      ),
    );
  }

//
  Widget joinMeetingBodyLandscape(
      JoinMeetingViewModel joinMeetingProvider,
      MethodChannelCoordinator methodChannelProvider,
      MeetingViewModel meetingProvider,
      BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 60,
              ),
              titleFlutterDemo(10),
              joinButton(joinMeetingProvider, methodChannelProvider,
                  meetingProvider, context),
              loadingIcon(joinMeetingProvider),
              errorMessage(joinMeetingProvider),
            ],
          ),
        ),
      ),
    );
  }

//
  Widget joinButton(
      JoinMeetingViewModel joinMeetingProvider,
      MethodChannelCoordinator methodChannelProvider,
      MeetingViewModel meetingProvider,
      BuildContext context) {
    return ElevatedButton(
      child: const Text("Join Meeting"),
      onPressed: () async {
        if (!joinMeetingProvider.joinButtonClicked) {
          // Prevent multiple clicks
          joinMeetingProvider.joinButtonClicked = true;

          // Hide Keyboard
          FocusManager.instance.primaryFocus?.unfocus();

          String meeetingId = widget.conferenceId;
          String attendeeId = '-aaaaaaaaaaaaaaaaaaaaaaaaaaaaa';

          if (joinMeetingProvider.verifyParameters(meeetingId, attendeeId)) {
            // Observers should be initialized before MethodCallHandler
            methodChannelProvider.initializeObservers(meetingProvider);
            methodChannelProvider.initializeMethodCallHandler();

            // Call api, format to JSON and send to native
            bool isMeetingJoined = await joinMeetingProvider.joinMeeting(
                meetingProvider, methodChannelProvider, meeetingId, attendeeId);
            if (isMeetingJoined) {
              print('entro y redirigjo');
              // ignore: use_build_context_synchronously
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MeetingView(
                      joinMeetingProvider: joinMeetingProvider,
                      methodChannelProvider: methodChannelProvider,
                      meetingProvider: meetingProvider),
                ),
              );
            }
          }
          joinMeetingProvider.joinButtonClicked = false;
        }
      },
    );
  }

  Widget titleFlutterDemo(double pad) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: pad),
      child: const Text(
        "Flutter Demo",
        style: TextStyle(
          fontSize: 32,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget meetingTextField(meetingIdTEC) {
    return TextField(
      controller: meetingIdTEC,
      decoration: const InputDecoration(
        labelText: "Meeting ID",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget attendeeTextField(attendeeIdTEC) {
    return TextField(
      controller: attendeeIdTEC,
      decoration: const InputDecoration(
        labelText: "Attendee Name",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget loadingIcon(JoinMeetingViewModel joinMeetingProvider) {
    if (joinMeetingProvider.loadingStatus) {
      return const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: CircularProgressIndicator());
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget errorMessage(JoinMeetingViewModel joinMeetingProvider) {
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
