/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:recparenting/src/conference/ui/screenshare.dart';

import '../provider/meeting_provider.dart';
import 'dart:developer' as developer;

class MeetingScreen extends StatefulWidget {


  const MeetingScreen(
      {Key? key})
      : super(key: key);

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final meetingProvider = Provider.of<MeetingProvider>(context);
    final orientation = MediaQuery.of(context).orientation;

    if (!meetingProvider.isMeetingActive) {
      developer.log('no esta actuvi?');
      Navigator.maybePop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${meetingProvider.meetingId}"),
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: true,
      body: meetingBody(orientation, meetingProvider, context)

    );
  }

  //
  Widget meetingBody(Orientation orientation, MeetingProvider meetingProvider,
      BuildContext context) {
    developer.log('********************** meetingBody **********************');
    if (orientation == Orientation.portrait) {
      return meetingBodyPortrait(meetingProvider, orientation, context);
    } else {
      return meetingBodyLandscape(meetingProvider, orientation, context);
    }
  }

  //
  Widget meetingBodyPortrait(MeetingProvider meetingProvider,
      Orientation orientation, BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: displayVideoTiles(meetingProvider, orientation, context),
          ),
          Column(
            children: displayAttendees(meetingProvider, context),
          ),
          WillPopScope(
            onWillPop: () async {
              meetingProvider.stopMeeting();
              return true;
            },
            child: const Spacer(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: SizedBox(
              height: 10,
              width: 300,
              child: leaveMeetingButton(meetingProvider, context),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> displayAttendees(
      MeetingProvider meetingProvider, BuildContext context) {
    List<Widget> attendees = [];
    if (meetingProvider.currAttendees
        .containsKey(meetingProvider.localAttendeeId)) {
      attendees.add(localListInfo(meetingProvider, context));
    }
    if (meetingProvider.currAttendees.length > 1) {
      if (meetingProvider.currAttendees
          .containsKey(meetingProvider.remoteAttendeeId)) {
        attendees.add(remoteListInfo(meetingProvider));
      }
    }

    return attendees;
  }

  Widget localListInfo(MeetingProvider meetingProvider, BuildContext context) {

    developer.log('localListInfo');

    return ListTile(
      title: FutureBuilder<String>(
          future: meetingProvider.formatExternalUserId(meetingProvider
              .currAttendees[meetingProvider.localAttendeeId]?.externalUserId), // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            developer.log('localListInfo ${snapshot.data}');

            if (snapshot.hasData) {
              return Text(
                  snapshot.data,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ));
            } else {
              return const SizedBox.shrink();
            }
          }
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.headphones),
            iconSize: 26,
            color: Colors.blue,
            onPressed: () {
              showAudioDeviceDialog(meetingProvider, context);
            },
          ),
          IconButton(
            icon: Icon(localMuteIcon(meetingProvider)),
            iconSize: 26,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            color: Colors.blue,
            onPressed: () {
              meetingProvider.sendLocalMuteToggle();
            },
          ),
          IconButton(
            icon: Icon(localVideoIcon(meetingProvider)),
            iconSize: 26,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            constraints: const BoxConstraints(),
            color: Colors.blue,
            onPressed: () {
              meetingProvider.sendLocalVideoTileOn();
            },
          ),
        ],
      ),
    );
  }

  Widget remoteListInfo(MeetingProvider meetingProvider) {
    developer.log('remoteListInfo');
    return (ListTile(
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Icon(
              remoteMuteIcon(meetingProvider),
              size: 26,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Icon(
              remoteVideoIcon(meetingProvider),
              size: 26,
            ),
          ),
        ],
      ),
      title: FutureBuilder<String>(
          future: meetingProvider.formatExternalUserId(meetingProvider
              .currAttendees[meetingProvider.remoteAttendeeId]?.externalUserId), // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            developer.log('remoteListInfo ${snapshot.data}');

            if (snapshot.hasData) {
              return Text(
                  snapshot.data,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ));
            } else {
              return const SizedBox.shrink();
            }
          }
      ),
    ));
  }

  //
  Widget meetingBodyLandscape(MeetingProvider meetingProvider,
      Orientation orientation, BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: displayVideoTiles(meetingProvider, orientation, context),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Attendees",
                style: TextStyle(fontSize: 34),
              ),
              Column(
                children: displayAttendeesLanscape(meetingProvider, context),
              ),
              WillPopScope(
                onWillPop: () async {
                  meetingProvider.stopMeeting();
                  return true;
                },
                child: const Spacer(),
              ),
              leaveMeetingButton(meetingProvider, context),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> displayAttendeesLanscape(
      MeetingProvider meetingProvider, BuildContext context) {
    List<Widget> attendees = [];
    if (meetingProvider.currAttendees
        .containsKey(meetingProvider.localAttendeeId)) {
      attendees.add(localListInfoLandscape(meetingProvider, context));
    }
    if (meetingProvider.currAttendees.length > 1) {
      if (meetingProvider.currAttendees
          .containsKey(meetingProvider.remoteAttendeeId)) {
        attendees.add(remoteListInfoLandscape(meetingProvider));
      }
    }

    return attendees;
  }

  Widget localListInfoLandscape(
      MeetingProvider meetingProvider, BuildContext context) {
    return SizedBox(
      width: 500,
      child: ListTile(
        title: FutureBuilder<String>(
      future: meetingProvider.formatExternalUserId(meetingProvider
          .currAttendees[meetingProvider.localAttendeeId]?.externalUserId), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Text(
                snapshot.data,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ));
          } else {
            return const SizedBox.shrink();
          }
        }
    ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.headphones),
              iconSize: 26,
              color: Colors.blue,
              onPressed: () {
                showAudioDeviceDialog(meetingProvider, context);
              },
            ),
            IconButton(
              icon: Icon(localMuteIcon(meetingProvider)),
              iconSize: 26,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              color: Colors.blue,
              onPressed: () {
                meetingProvider.sendLocalMuteToggle();
              },
            ),
            IconButton(
              icon: Icon(localVideoIcon(meetingProvider)),
              iconSize: 26,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              constraints: const BoxConstraints(),
              color: Colors.blue,
              onPressed: () {
                meetingProvider.sendLocalVideoTileOn();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget remoteListInfoLandscape(MeetingProvider meetingProvider) {
    return SizedBox(
      width: 500,
      child: ListTile(
        title: FutureBuilder<String>(
          future: meetingProvider.formatExternalUserId(meetingProvider
              .currAttendees[meetingProvider.remoteAttendeeId]?.externalUserId), // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Text(
                  snapshot.data,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ));
            } else {
              return const SizedBox.shrink();
            }
          }
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Icon(
                remoteMuteIcon(meetingProvider),
                size: 26,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Icon(
                remoteVideoIcon(meetingProvider),
                size: 26,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //
  void openFullscreenDialog(
      BuildContext context, int? params, MeetingProvider meetingProvider) {
    Widget contentTile;

    developer.log('********************** openFullscreenDialog **********************');
    if (Platform.isIOS) {
      contentTile = UiKitView(
        viewType: "videoTile",
        creationParams: params,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (Platform.isAndroid) {
      contentTile = PlatformViewLink(
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
            creationParams: params,
            creationParamsCodec: const StandardMessageCodec(),
            onFocus: () => params.onFocusChanged,
          );
          controller
              .addOnPlatformViewCreatedListener(params.onPlatformViewCreated);
          controller.create();
          return controller;
        },
      );
    } else {
      contentTile = const Text("Unrecognized Platform.");
    }

    if (!meetingProvider.isReceivingScreenShare) {
      developer.log('no esta recibiendo screen share TODO no se estan pasando los providers');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const MeetingScreen()));
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                        onDoubleTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MeetingScreen())),
                        child: contentTile),
                  ),
                ),
              ],
            ),
          );
        },
        fullscreenDialog: true,
      ),
    );
  }

  List<Widget> displayVideoTiles(MeetingProvider meetingProvider,
      Orientation orientation, BuildContext context) {
    Widget screenShareWidget = Expanded(
        child: videoTile(meetingProvider, context,
            isLocal: false, isContent: true));

    Widget localVideoTile =
        videoTile(meetingProvider, context, isLocal: true, isContent: false);

    Widget remoteVideoTile =
        videoTile(meetingProvider, context, isLocal: false, isContent: false);

    if (meetingProvider.currAttendees
        .containsKey(meetingProvider.contentAttendeeId)) {
      if (meetingProvider.isReceivingScreenShare) {
        developer.log('recibiendo screen share');
        return [screenShareWidget];
      }
    }

    List<Widget> videoTiles = [];

    if (meetingProvider
            .currAttendees[meetingProvider.localAttendeeId]?.isVideoOn ??
        false) {
      if (meetingProvider
              .currAttendees[meetingProvider.localAttendeeId]?.videoTile !=
          null) {
        videoTiles.add(localVideoTile);
      }
    }
    if (meetingProvider.currAttendees.length > 1) {
      if (meetingProvider.currAttendees
          .containsKey(meetingProvider.remoteAttendeeId)) {
        if ((meetingProvider.currAttendees[meetingProvider.remoteAttendeeId]
                    ?.isVideoOn ??
                false) &&
            meetingProvider.currAttendees[meetingProvider.remoteAttendeeId]
                    ?.videoTile !=
                null) {
          videoTiles.add(Container(child: remoteVideoTile));
        }
      }
    }

    if (videoTiles.isEmpty) {
      const Widget emptyVideos = Text("No video detected");
      if (orientation == Orientation.portrait) {
        videoTiles.add(
          emptyVideos,
        );
      } else {
        videoTiles.add(
          const Center(
            widthFactor: 2.5,
            child: emptyVideos,
          ),
        );
      }
    }

    return videoTiles;
  }

  Widget contentVideoTile(
      int? paramsVT, MeetingProvider meetingProvider, BuildContext context) {
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
            onFocus: () => params.onFocusChanged,
          );
          controller
              .addOnPlatformViewCreatedListener(params.onPlatformViewCreated);
          controller.create();
          return controller;
        },
      );
    } else {
      videoTile = const Text("Unrecognized Platform.");
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        width: 200,
        height: 230,
        child: GestureDetector(
          onDoubleTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ScreenShare(paramsVT: paramsVT)));
          },
          child: videoTile,
        ),
      ),
    );
  }

  Widget videoTile(MeetingProvider meetingProvider, BuildContext context,
      {required bool isLocal, required bool isContent}) {
    int? paramsVT;

    developer.log('********************** videoTile **********************');
    developer.log('isContent $isContent');
    developer.log('isLocal $isLocal');
    if (isContent) {
      if (meetingProvider.contentAttendeeId != null) {
        if (meetingProvider
                .currAttendees[meetingProvider.contentAttendeeId]?.videoTile !=
            null) {
          developer.log('cargo el content video tile    ');
          paramsVT = meetingProvider
              .currAttendees[meetingProvider.contentAttendeeId]
              ?.videoTile
              ?.tileId as int;
          return contentVideoTile(paramsVT, meetingProvider, context);
        }
      }
    } else if (isLocal) {
      developer.log(meetingProvider.currAttendees.toString());
      developer.log(meetingProvider.localAttendeeId.toString());

      paramsVT = meetingProvider
          .currAttendees[meetingProvider.localAttendeeId]?.videoTile?.tileId;
    } else {
      paramsVT = meetingProvider
          .currAttendees[meetingProvider.remoteAttendeeId]?.videoTile?.tileId;
    }

    developer.log('paramsVT $paramsVT');
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
      videoTile = const Text("Unrecognized Platform.");
    }

    developer.log('videoTile $videoTile');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 230,
        child: videoTile,
      ),
    );
  }

  void showAudioDeviceDialog(
      MeetingProvider meetingProvider, BuildContext context) async {
    String? device = await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Choose Audio Device"),
            elevation: 40,
            titleTextStyle: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold),
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
          child: Text(
            meetingProvider.deviceList[i] as String,
            style: TextStyle(color: Colors.black, fontWeight: weight),
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
      style: ElevatedButton.styleFrom(primary: Colors.red),
      onPressed: () {
        meetingProvider.stopMeeting();
        Navigator.pop(context);
      },
      child: const Text("Leave Meeting"),
    );
  }

  IconData localMuteIcon(MeetingProvider meetingProvider) {
    developer.log('********************************************');
    developer.log('el estado del mute es');
    developer.log(meetingProvider.currAttendees[meetingProvider.localAttendeeId]!.muteStatus.toString());
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
