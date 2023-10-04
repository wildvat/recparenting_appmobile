import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recparenting/_shared/models/text_sizes.enum.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
import 'package:recparenting/_shared/ui/widgets/title.widget.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/src/conference/models/meeting.model.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';

import '../../../_shared/models/text_colors.enum.dart';
import '../../../_shared/models/user.model.dart';
import '../../../_shared/ui/widgets/scaffold_default.dart';
import '../../current_user/helpers/current_user_builder.dart';
import '../provider/conference.provider.dart';
import '../provider/join_meeting_provider.dart';
import '../provider/meeting_provider.dart';
import '../provider/method_channel_coordinator.dart';
import 'meeting.screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class JoinMeetingScreen extends StatefulWidget {
  final String _conferenceId;

  const JoinMeetingScreen({Key? key, required String conferenceId})
      : _conferenceId = conferenceId,
        super(key: key);

  @override
  State<JoinMeetingScreen> createState() => _JoinMeetingScreenState();
}

class _JoinMeetingScreenState extends State<JoinMeetingScreen> {
  late User _currentUser;
  Future<Meeting?>? _meeting;

  @override
  void initState() {
    super.initState();
    _currentUser = CurrentUserBuilder().value();

    if (_currentUser is Therapist) {
      _currentUser = (_currentUser as Therapist);
    }

    if (_currentUser is Patient) {
      final ConferenceApi api = ConferenceApi();
      _meeting = api.get(widget._conferenceId);
      _currentUser = (_currentUser as Patient);
    }
  }

  @override
  Widget build(BuildContext context) {
    final joinMeetingProvider = Provider.of<JoinMeetingProvider>(context);
    final methodChannelProvider =
        Provider.of<MethodChannelCoordinator>(context);
    final meetingProvider = Provider.of<MeetingProvider>(context);

    final orientation = MediaQuery.of(context).orientation;

    return joinMeetingBody(joinMeetingProvider, methodChannelProvider,
        meetingProvider, context, orientation);
  }

//
  Widget joinMeetingBody(
      JoinMeetingProvider joinMeetingProvider,
      MethodChannelCoordinator methodChannelProvider,
      MeetingProvider meetingProvider,
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
      JoinMeetingProvider joinMeetingProvider,
      MethodChannelCoordinator methodChannelProvider,
      MeetingProvider meetingProvider,
      BuildContext context) {
    return ScaffoldDefault(
      title: AppLocalizations.of(context)!.conferenceTitle,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
      JoinMeetingProvider joinMeetingProvider,
      MethodChannelCoordinator methodChannelProvider,
      MeetingProvider meetingProvider,
      BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 60,
            ),
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
  Widget joinButton(
      JoinMeetingProvider joinMeetingProvider,
      MethodChannelCoordinator methodChannelProvider,
      MeetingProvider meetingProvider,
      BuildContext context) {
    if (joinMeetingProvider.loadingStatus) {
      //return const SizedBox();
    }
    if (_currentUser.isTherapist()) {
      return ElevatedButton(
        child: TextDefault(AppLocalizations.of(context)!.conferenceTitle),
        onPressed: () async {
          if (!joinMeetingProvider.joinButtonClicked) {
            // Prevent multiple clicks
            joinMeetingProvider.joinButtonClicked = true;
            String meetingId = widget._conferenceId;

            if (joinMeetingProvider.verifyParameters(meetingId)) {
              // Observers should be initialized before MethodCallHandler
              methodChannelProvider.initializeObservers(meetingProvider);
              methodChannelProvider.initializeMethodCallHandler();

              // Call api, format to JSON and send to native
              bool isMeetingJoined = await joinMeetingProvider.joinMeeting(
                  meetingProvider,
                  methodChannelProvider,
                  meetingId,
                  _currentUser.id);
              if (isMeetingJoined) {
                // ignore: use_build_context_synchronously
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider.value(
                          value: meetingProvider,
                          child: const MeetingScreen())),
                );
              }
            }
            joinMeetingProvider.joinButtonClicked = false;
          }
        },
      );
    }
    if (_currentUser.isPatient() && _meeting != null) {
      return FutureBuilder<Meeting?>(
          future: _meeting,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox();
            } else {
              if (snapshot.hasData) {
                return ElevatedButton(
                  child:
                      TextDefault(AppLocalizations.of(context)!.conferenceJoin),
                  onPressed: () async {
                    if (!joinMeetingProvider.joinButtonClicked) {
                      // Prevent multiple clicks
                      joinMeetingProvider.joinButtonClicked = true;
                      String meetingId = widget._conferenceId;

                      if (joinMeetingProvider.verifyParameters(meetingId)) {
                        // Observers should be initialized before MethodCallHandler
                        methodChannelProvider
                            .initializeObservers(meetingProvider);
                        methodChannelProvider.initializeMethodCallHandler();

                        // Call api, format to JSON and send to native
                        bool isMeetingJoined =
                            await joinMeetingProvider.joinMeeting(
                                meetingProvider,
                                methodChannelProvider,
                                meetingId,
                                _currentUser.id);
                        if (isMeetingJoined) {
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ChangeNotifierProvider.value(
                                        value: meetingProvider,
                                        child: const MeetingScreen())),
                          );
                        }
                      }
                      joinMeetingProvider.joinButtonClicked = false;
                    }
                  },
                );
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    child: TextDefault(
                      'The videoconference must be initiated by the therapist.',
                      size: TextSizes.large,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  TitleDefault(
                    AppLocalizations.of(context)!.conferenceWaitingTherapist,
                    size: TitleSize.large,
                  ),
                ],
              );
            }
          });
    }

    return const SizedBox();
  }

  Widget loadingIcon(JoinMeetingProvider joinMeetingProvider) {
    if (joinMeetingProvider.loadingStatus) {
      return const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: CircularProgressIndicator(color: colorRec));
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
            child: TextDefault(
              "${joinMeetingProvider.errorMessage}",
              color: TextColors.danger,
            ),
          ),
        ),
      );
    } else if (joinMeetingProvider.info) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: TextDefault(
              "${joinMeetingProvider.errorMessage}",
              color: TextColors.success,
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
