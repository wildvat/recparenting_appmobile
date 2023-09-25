import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/room/bloc/conversation_bloc.dart';
import 'package:recparenting/src/room/ui/widgets/chat.widget.dart';

import '../../../../_shared/models/user.model.dart';
import '../../../../_shared/ui/widgets/app_submenu.widget.dart';
import '../../../../constants/colors.dart';
import '../../../current_user/bloc/current_user_bloc.dart';
import '../../../therapist/models/therapist.model.dart';
import '../../helpers/participans_from_room.dart';
import '../../models/rooms.model.dart';
import '../../providers/room.provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatScreen extends StatefulWidget {
  final Patient patient;

  const ChatScreen({required this.patient, super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Future<Rooms?> roomsShared;
  late User? currentUser;
  late ConversationBloc conversationBloc;
  late CurrentUserBloc currentUserBloc;

  @override
  void initState() {
    super.initState();
    currentUserBloc = context.read<CurrentUserBloc>();
    if (currentUserBloc.state is CurrentUserLoaded) {
      currentUser = (currentUserBloc.state as CurrentUserLoaded).user;
    } else {
      throw Exception('no hay usuario');
    }
    if (currentUser!.isTherapist()) {
      RoomApi roomApi = RoomApi();
      roomsShared =
          roomApi.getConversationSharedPatientWithTherapist(widget.patient);
    }
    if (currentUser!.isPatient()) {
      RoomApi roomApi = RoomApi();
      roomsShared =
          roomApi.getAll(1, null);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget withOutShared() {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.chatTitleWith(widget.patient.name)),
          actions: const [AppSubmenuWidget()],
        ),
        body: BlocProvider(
            create: (_) => ConversationBloc(roomId: widget.patient.room),
            child: ChatWidget(patient: widget.patient)));
  }

  Widget withShared(Rooms rooms) {
    List<Widget> tabs = [];
    List<Widget> tabsContent = [];

    if(currentUser!.isTherapist()) {
      tabs.add(Tab(text: AppLocalizations.of(context)!.chatTitleWithMe));
      tabsContent.add(BlocProvider(
          create: (_) => ConversationBloc(roomId: widget.patient.room),
          child: ChatWidget(patient: widget.patient)));
    }

    for (var room in rooms.rooms) {
      Therapist? therapist = getTherapistFromRoom(room, currentUser!);
      Patient? patient = getPatientFromRoom(room, currentUser!);

      if (currentUser!.isTherapist()) {
        if (patient != null && therapist != null) {
          tabs.add(Tab(text: therapist.name));
          tabsContent.add(BlocProvider(
              create: (_) => ConversationBloc(roomId: room.id),
              child: ChatWidget(patient: patient)));
        }
      } else if (currentUser!.isPatient()) {
        if (therapist != null && patient != null) {
          tabs.add(Tab(text: therapist.name));
          tabsContent.add(BlocProvider(
              create: (_) => ConversationBloc(roomId: room.id),
              child: ChatWidget(patient: patient)));
        }
      }
    }
    if (tabs.isEmpty) {
      return withOutShared();
    }
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: tabs,
          ),
          title: Text(AppLocalizations.of(context)!.chatTitleWith(widget.patient.name)),
        ),
        body: TabBarView(
          children: tabsContent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {


    return FutureBuilder(
        future: roomsShared,
        builder: (BuildContext context, AsyncSnapshot<Rooms?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: SizedBox(
                    height: 40,
                    child: CircularProgressIndicator(color: colorRec)));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.rooms.isNotEmpty) {
              return withShared(snapshot.data!);
            } else {
              return withOutShared();
            }
          }
          return withOutShared();
        });
  }
}
