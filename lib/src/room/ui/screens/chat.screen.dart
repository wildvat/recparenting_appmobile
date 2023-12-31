import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:recparenting/src/current_user/helpers/current_user_builder.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/room/bloc/conversation_bloc.dart';
import 'package:recparenting/src/room/models/room.model.dart';
import 'package:recparenting/src/room/ui/widgets/chat.widget.dart';

import '../../../../_shared/models/user.model.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/router_names.dart';
import '../../../therapist/models/therapist.model.dart';
import '../../helpers/participans_from_room.dart';
import '../../models/rooms.model.dart';
import '../../providers/room.provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatScreen extends StatefulWidget {
  final Patient _patient;

  const ChatScreen({required Patient patient, super.key}) : _patient = patient;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  late User _currentUser;
  final RoomApi _roomApi = RoomApi();

  Widget withOutShared() {
    return ScaffoldDefault(
        title:
            AppLocalizations.of(context)!.chatTitleWith(widget._patient.name),
        body: BlocProvider(
            create: (_) => ConversationBloc(roomId: widget._patient.room!),
            child: ChatWidget(patient: widget._patient)));
  }

  Widget withShared(Rooms rooms) {
    List<Widget> tabs = [];
    List<Widget> tabsContent = [];

    if (_currentUser.isTherapist()) {
      //Si es terapeuta el roomsShared solo devuelve room si esta compartido con el terapeuta
      // por lo que tengo que añadir a los tabs la actual conversacion con el paciente
      tabs.add(Tab(text: widget._patient.getFullName()));
      tabsContent.add(BlocProvider(
          create: (_) => ConversationBloc(roomId: widget._patient.room!),
          child: ChatWidget(patient: widget._patient)));
    }

    for (var room in rooms.rooms) {
      Therapist? therapist = getTherapistFromRoom(room);
      Patient? patient = getPatientFromRoom(room);

      if (patient != null && therapist != null) {
        tabs.add(Tab(text: therapist.name));
        tabsContent.add(BlocProvider(
            create: (_) => ConversationBloc(roomId: room.id),
            child: ChatWidget(patient: patient)));
      }
    }
    if (tabs.isEmpty) {
      return withOutShared();
    }
    final tabController = TabController(length: tabs.length, vsync: this);

    String title = AppLocalizations.of(context)!.menuChat;
    if (_currentUser.isTherapist()) {
      Therapist? therapistOfRoom =
          getTherapistFromRoom(rooms.rooms[tabController.index]);
      if (therapistOfRoom != null) {
        title =
            AppLocalizations.of(context)!.chatTitleWith(therapistOfRoom.name);
      }
    }
    return DefaultTabController(
      length: tabs.length,
      child: ScaffoldDefault(
        title: title,
        actionButton: (_currentUser.isPatient())
            ? IconButton(
                onPressed: () {
                  Room room = rooms.rooms[tabController.index];
                  Navigator.pushNamed(context, therapistBioPageRoute,
                      arguments: getTherapistFromRoom(room));
                },
                icon: const Icon(Icons.badge_outlined))
            : const SizedBox(),
        tabBar: TabBar(
          controller: tabController,
          indicatorColor: colorRecDark,
          dividerColor: Colors.transparent,
          indicator: const BoxDecoration(),
          tabs: tabs,
        ),
        body: TabBarView(
          controller: tabController,
          children: tabsContent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _currentUser = CurrentUserBuilder().value();
    return FutureBuilder(
        //future: _roomsShared,
        future: _currentUser.isTherapist()
            ? _roomApi
                .getConversationSharedPatientWithTherapist(widget._patient)
            : _roomApi.getAll(1, null),
        builder: (BuildContext context, AsyncSnapshot<Rooms?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ScaffoldDefault(
                title: AppLocalizations.of(context)!.menuChat,
                body: const Center(
                    child: SizedBox(
                        height: 40,
                        child: CircularProgressIndicator(color: colorRec))));
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
