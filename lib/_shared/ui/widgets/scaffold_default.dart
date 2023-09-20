import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/_shared/ui/widgets/app_submenu.widget.dart';
import 'package:recparenting/src/patient/ui/bottom_bar_patient.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:recparenting/src/current_user/bloc/current_user_bloc.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';

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

  @override
  void initState() {
    super.initState();
    _currentUser =
        (context.read<CurrentUserBloc>().state as CurrentUserLoaded).user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((widget.title != null) ? widget.title! : 'REC Parenting'),
        actions: [
          widget.actionButton ?? const SizedBox.shrink(),
          const AppSubmenuWidget()
        ],
        bottom: widget.tabBar,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _currentUser is Patient
          ? FloatingActionButton(
              child: const Icon(Icons.message),
              onPressed: () {
                Navigator.pushReplacementNamed(context, chatPageRoute,
                    arguments: _currentUser);
              },
            )
          : FloatingActionButton(
              child: const Icon(Icons.person_search),
              onPressed: () {},
            ),
      bottomNavigationBar: _currentUser is Patient
          ? BottomAppBarPatient(patient: _currentUser as Patient)
          : const SizedBox.shrink(),
      body: SafeArea(child: widget.body),
      //floatingActionButton: widget.floatingActionButton
    );
  }
}
