import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/_shared/ui/widgets/app_submenu.widget.dart';
import 'package:recparenting/src/notifications/bloc/notification_bloc.dart';
import 'package:recparenting/src/patient/ui/widgets/bottom_bar_patient.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:recparenting/src/current_user/bloc/current_user_bloc.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';
import 'package:recparenting/src/therapist/ui/widgets/botton_bar_therapist.dart';

class ScaffoldDefault extends StatelessWidget {
  late Widget body;
  final String? title;
  final FloatingActionButton? floatingActionButton;
  final Widget? actionButton;
  final PreferredSizeWidget? tabBar;
  final Color backgroundColor;

  ScaffoldDefault(
      {required this.body,
      this.title,
      this.floatingActionButton,
      this.actionButton,
      this.tabBar,
      this.backgroundColor = Colors.white,
      super.key});

  late User _currentUser;

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    _currentUser =
        (context.read<CurrentUserBloc>().state as CurrentUserLoaded).user;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(title ?? 'REC Parenting'),
        actions: [
          actionButton ?? const SizedBox.shrink(),
          BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
            if (state is NotificationsLoaded &&
                state.notifications.notifications.isNotEmpty) {
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
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        state.notifications.notifications.length.toString(),
                        style: const TextStyle(
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
        bottom: tabBar,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: keyboardIsOpened
          ? null
          : _currentUser is Patient
              ? ModalRoute.of(context)!.settings.name != '/chat'
                  ? FloatingActionButton(
                      backgroundColor: TextColors.chat.color,
                      child: const Icon(Icons.message),
                      onPressed: () {
                        Navigator.pushNamed(context, chatRoute,
                            arguments: _currentUser);
                      },
                    )
                  : const SizedBox.shrink()
              : FloatingActionButton(
                  backgroundColor: TextColors.chat.color,
                  child: const Icon(Icons.person_search),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, patientsRoute);
                  },
                ),
      bottomNavigationBar: _currentUser is Patient
          ? BottomAppBarPatient(patient: _currentUser as Patient)
          : BottomAppBarTherapist(therapist: _currentUser as Therapist),
      body: SafeArea(child: body),
      //floatingActionButton: widget.floatingActionButton
    );
  }
}
