import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/_shared/ui/widgets/app_submenu.widget.dart';
import 'package:recparenting/src/notifications/bloc/notification_bloc.dart';
import 'package:recparenting/src/patient/ui/widgets/bottom_bar_patient.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:recparenting/src/current_user/bloc/current_user_bloc.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';
import 'package:recparenting/src/therapist/ui/widgets/botton_bar_therapist.dart';

class ScaffoldDefault extends StatefulWidget {
  late Widget body;
  final String? title;
  final FloatingActionButton? floatingActionButton;
  final Widget? actionButton;
  final TabBar? tabBar;

  ScaffoldDefault(
      {required this.body,
      this.title,
      this.floatingActionButton,
      this.actionButton,
      this.tabBar,
      super.key});

  @override
  State<ScaffoldDefault> createState() => _ScaffoldDefaultState();
}

class _ScaffoldDefaultState extends State<ScaffoldDefault> {
  late User _currentUser;
  late NotificationBloc _notificationBloc;
  @override
  void initState() {
    super.initState();
    _currentUser =
        (context.read<CurrentUserBloc>().state as CurrentUserLoaded).user;
    _notificationBloc = context.read<NotificationBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((widget.title != null) ? widget.title! : 'REC Parenting'),
        actions: [
          widget.actionButton ?? const SizedBox.shrink(),
          BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
                if (state is NotificationsLoaded && state.notifications.total > 0) {
                  return Stack(
                    children: <Widget>[
                      IconButton(
                        padding: const EdgeInsets.all(0),
                        icon: const Icon(Icons.notifications),
                        onPressed: () {
                          Navigator.pushNamed(context, notificationsRoute,
                              arguments: state.notifications);
                        },
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child:  Container(
                          padding: const EdgeInsets.all(2),
                          decoration:  BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child:  Text(
                            state.notifications.notifications.length.toString(),
                            style:  const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  );
                }
                return const SizedBox();
              }),
          const AppSubmenuWidget()
        ],
        bottom: widget.tabBar,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _currentUser is Patient
          ? FloatingActionButton(
              child: const Icon(Icons.message),
              onPressed: () {
                Navigator.pushNamed(context, chatRoute,
                    arguments: _currentUser);
              },
            )
          : FloatingActionButton(
              child: const Icon(Icons.person_search),
              onPressed: () {
                Navigator.pushReplacementNamed(context, patientsRoute);
              },
            ),
      bottomNavigationBar: _currentUser is Patient
          ? BottomAppBarPatient(patient: _currentUser as Patient)
          : BottomAppBarTherapist(therapist: _currentUser as Therapist),
      body: SafeArea(child: widget.body),
      //floatingActionButton: widget.floatingActionButton
    );
  }
}
