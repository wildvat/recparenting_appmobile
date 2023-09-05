import 'package:flutter/material.dart';

import 'package:recparenting/_shared/ui/drawer.dart';

class ScaffoldDefault extends StatefulWidget {
  late Widget body;
  String? title;
  FloatingActionButton? floatingActionButton;

  ScaffoldDefault(
      {required this.body, this.title, this.floatingActionButton, Key? key})
      : super(key: key);

  @override
  State<ScaffoldDefault> createState() => _ScaffoldDefaultState();
}

class _ScaffoldDefaultState extends State<ScaffoldDefault> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:
                Text((widget.title != null) ? widget.title! : 'REC Parenting')),
        endDrawer: const DrawerApp(),
        body: SafeArea(child: widget.body),
        floatingActionButton: widget.floatingActionButton);
  }
}
