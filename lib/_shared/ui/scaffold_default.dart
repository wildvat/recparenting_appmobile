import 'package:flutter/material.dart';
import 'package:recparenting/_shared/ui/app_submenu.widget.dart';

class ScaffoldDefault extends StatefulWidget {
  late Widget body;
  final String? title;
  final FloatingActionButton? floatingActionButton;
  final IconButton? actionButton;

  ScaffoldDefault(
      {required this.body,
      this.title,
      this.floatingActionButton,
      this.actionButton,
      super.key});

  @override
  State<ScaffoldDefault> createState() => _ScaffoldDefaultState();
}

class _ScaffoldDefaultState extends State<ScaffoldDefault> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text((widget.title != null) ? widget.title! : 'REC Parenting'),
          actions: [
            widget.actionButton ?? const SizedBox.shrink(),
            const AppSubmenuWidget()
          ],
        ),
        //endDrawer: const DrawerApp(),
        body: SafeArea(child: widget.body),
        floatingActionButton: widget.floatingActionButton);
  }
}
