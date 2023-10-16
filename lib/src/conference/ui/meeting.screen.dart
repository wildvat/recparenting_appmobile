import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
import 'package:recparenting/_shared/ui/widgets/title.widget.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:recparenting/src/current_user/helpers/current_user_builder.dart';

import '../provider/meeting_provider.dart';
import 'dart:developer' as developer;

class MeetingScreen extends StatefulWidget {
  const MeetingScreen({Key? key}) : super(key: key);

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  final User _currentUser = CurrentUserBuilder().value();
  /*
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
  */

  @override
  Widget build(BuildContext context) {
    final meetingProvider = Provider.of<MeetingProvider>(context);
    final orientation = MediaQuery.of(context).orientation;

    if (!meetingProvider.isMeetingActive) {
      Navigator.maybePop(context);
    }

    return Scaffold(
        backgroundColor: TextColors.light.color,
        resizeToAvoidBottomInset: false,
        body: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Stack(
              alignment: Alignment.center,
              children: [
                displayVideoTileRemote(meetingProvider, orientation, context),
                Positioned(
                  top: const Size.fromHeight(kToolbarHeight).height,
                  left: 10,
                  child:
                      showLocalVideoTile(meetingProvider, context, orientation),
                ),
                Positioned(
                  bottom: 20,
                  child: localListInfo(meetingProvider, context),
                ),
                WillPopScope(
                  onWillPop: () async {
                    meetingProvider.stopMeeting();
                    return true;
                  },
                  child: const SizedBox.shrink(),
                ),
              ],
            )));
  }

  Widget showRemoteVideoTile(
      MeetingProvider meetingProvider, BuildContext context) {
    int? paramsVT;

    paramsVT = meetingProvider
        .currAttendees[meetingProvider.remoteAttendeeId]?.videoTile?.tileId;

    developer.log('paramsVT $paramsVT');
    Widget videoTile;
    if (Platform.isIOS) {
      videoTile = SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: UiKitView(
            viewType: "videoTile",
            creationParams: paramsVT,
            creationParamsCodec: const StandardMessageCodec(),
          ));
    } else if (Platform.isAndroid) {
      videoTile = SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: PlatformViewLink(
          viewType: 'videoTile',
          surfaceFactory:
              (BuildContext context, PlatformViewController controller) {
            return AndroidViewSurface(
              controller: controller as AndroidViewController,
              gestureRecognizers: const <Factory<
                  OneSequenceGestureRecognizer>>{},
              hitTestBehavior: PlatformViewHitTestBehavior.transparent,
            );
          },
          onCreatePlatformView: (PlatformViewCreationParams params) {
            final AndroidViewController controller =
                PlatformViewsService.initExpensiveAndroidView(
              id: params.id,
              viewType: 'videoTile',
              layoutDirection: TextDirection.ltr,
              creationParams: paramsVT,
              creationParamsCodec: const StandardMessageCodec(),
            );
            controller
                .addOnPlatformViewCreatedListener(params.onPlatformViewCreated);
            controller.create();
            return controller;
          },
        ),
      );
    } else {
      videoTile =
          TextDefault(AppLocalizations.of(context)!.mettingErrorPlatform);
    }

    return videoTile;
  }

  Widget localListInfo(MeetingProvider meetingProvider, BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              showAudioDeviceDialog(meetingProvider, context);
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(20),
              backgroundColor: colorRec, // <-- Button color
              foregroundColor: colorRecLight, // <-- Splash color
            ),
            child: const Icon(Icons.headphones, color: Colors.white),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
          ElevatedButton(
            onPressed: () {
              meetingProvider.sendLocalMuteToggle();
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(20),
              backgroundColor: colorRec, // <-- Button color
              foregroundColor: colorRecLight, // <-- Splash color
            ),
            child: Icon(localMuteIcon(meetingProvider), color: Colors.white),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
          ElevatedButton(
            onPressed: () {
              meetingProvider.sendLocalVideoTileOn();
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(20),
              backgroundColor: colorRec, // <-- Button color
              foregroundColor: colorRecLight, // <-- Splash color
            ),
            child: Icon(localVideoIcon(meetingProvider), color: Colors.white),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
          ElevatedButton(
            onPressed: () {
              meetingProvider.stopMeeting();
              leaveMeetingButton(meetingProvider, context);
              Navigator.pushReplacementNamed(
                  context, homeRoute);
              //Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(20),
              backgroundColor: TextColors.danger.color, // <-- Button color
              foregroundColor: TextColors.danger.color, // <-- Splash color
            ),
            child: const Icon(Icons.power_settings_new_outlined,
                color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget showLocalVideoTile(MeetingProvider meetingProvider,
      BuildContext context, Orientation orientation) {
    int? paramsVT;

    paramsVT = meetingProvider
        .currAttendees[meetingProvider.localAttendeeId]?.videoTile?.tileId;

    if (!meetingProvider
        .currAttendees[meetingProvider.localAttendeeId]!.isVideoOn) {
      return const SizedBox();
    }
    Widget videoTile;
    if (Platform.isIOS) {
      videoTile = UiKitView(
        viewType: "videoTile",
        creationParams: paramsVT,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (Platform.isAndroid) {
      videoTile = PlatformViewLink(
        viewType: 'videoTile',
        surfaceFactory:
            (BuildContext context, PlatformViewController controller) {
          return AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (PlatformViewCreationParams params) {
          final AndroidViewController controller =
              PlatformViewsService.initExpensiveAndroidView(
            id: params.id,
            viewType: 'videoTile',
            layoutDirection: TextDirection.ltr,
            creationParams: paramsVT,
            creationParamsCodec: const StandardMessageCodec(),
          );
          controller
              .addOnPlatformViewCreatedListener(params.onPlatformViewCreated);
          controller.create();
          return controller;
        },
      );
    } else {
      videoTile =
          TextDefault(AppLocalizations.of(context)!.mettingErrorPlatform);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        width: MediaQuery.of(context).size.width /
            ((orientation == Orientation.portrait) ? 4 : 6),
        height: MediaQuery.of(context).size.height /
            ((orientation == Orientation.portrait) ? 6 : 4),
        child: videoTile,
      ),
    );
  }

  Widget displayVideoTileRemote(MeetingProvider meetingProvider,
      Orientation orientation, BuildContext context) {
    if (meetingProvider.currAttendees.length > 1) {
      if (meetingProvider.currAttendees
          .containsKey(meetingProvider.remoteAttendeeId)) {
        if ((meetingProvider.currAttendees[meetingProvider.remoteAttendeeId]
                    ?.isVideoOn ??
                false) &&
            meetingProvider.currAttendees[meetingProvider.remoteAttendeeId]
                    ?.videoTile !=
                null) {
          return showRemoteVideoTile(meetingProvider, context);
        }
      }
    }

    Widget emptyVideos = TitleDefault(
      AppLocalizations.of(context)!.meetingWaitingToCamera(
          _currentUser.isPatient() ? 'therapist' : 'patient'),
      size: TitleSize.large,
      textAlign: TextAlign.center,
    );
    return Center(
      child: emptyVideos,
    );
  }

  void showAudioDeviceDialog(
      MeetingProvider meetingProvider, BuildContext context) async {
    String? device = await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title:
                TextDefault(AppLocalizations.of(context)!.mettingChooseAudio),
            elevation: 40,
            titleTextStyle: const TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            backgroundColor: Colors.white,
            children:
                getSimpleDialogOptionsAudioDevices(meetingProvider, context),
          );
        });
    if (device == null) {
      developer.log("No device chosen.");
      return;
    }

    meetingProvider.updateCurrentDevice(device);
  }

  List<Widget> getSimpleDialogOptionsAudioDevices(
      MeetingProvider meetingProvider, BuildContext context) {
    List<Widget> dialogOptions = [];
    FontWeight weight;
    for (var i = 0; i < meetingProvider.deviceList.length; i++) {
      if (meetingProvider.deviceList[i] ==
          meetingProvider.selectedAudioDevice) {
        weight = FontWeight.bold;
      } else {
        weight = FontWeight.normal;
      }
      dialogOptions.add(
        SimpleDialogOption(
          child: TextDefault(
            meetingProvider.deviceList[i] as String,
            color: TextColors.dark,
            fontWeight: weight,
          ),
          onPressed: () {
            developer.log("${meetingProvider.deviceList[i]} was chosen.");
            Navigator.pop(context, meetingProvider.deviceList[i]);
          },
        ),
      );
    }
    return dialogOptions;
  }

  Widget leaveMeetingButton(
      MeetingProvider meetingProvider, BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        meetingProvider.stopMeeting();
        Navigator.pushReplacementNamed(
            context, homeRoute);
      //  Navigator.pop(context);
      },
      child: TextDefault(AppLocalizations.of(context)!.mettingLeave),
    );
  }

  IconData localMuteIcon(MeetingProvider meetingProvider) {
    developer.log('********************************************');
    developer.log('el estado del mute es');
    developer.log(meetingProvider
        .currAttendees[meetingProvider.localAttendeeId]!.muteStatus
        .toString());
    developer.log('********************************************');

    if (!meetingProvider
        .currAttendees[meetingProvider.localAttendeeId]!.muteStatus) {
      return Icons.mic;
    } else {
      return Icons.mic_off;
    }
  }

  IconData remoteMuteIcon(MeetingProvider meetingProvider) {
    if (!meetingProvider
        .currAttendees[meetingProvider.remoteAttendeeId]!.muteStatus) {
      return Icons.mic;
    } else {
      return Icons.mic_off;
    }
  }

  IconData localVideoIcon(MeetingProvider meetingProvider) {
    if (meetingProvider
        .currAttendees[meetingProvider.localAttendeeId]!.isVideoOn) {
      return Icons.videocam;
    } else {
      return Icons.videocam_off;
    }
  }

  IconData remoteVideoIcon(MeetingProvider meetingProvider) {
    if (meetingProvider
        .currAttendees[meetingProvider.remoteAttendeeId]!.isVideoOn) {
      return Icons.videocam;
    } else {
      return Icons.videocam_off;
    }
  }
}
