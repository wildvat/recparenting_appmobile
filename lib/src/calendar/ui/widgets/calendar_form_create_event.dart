import 'package:flutter/material.dart';

class CalendarFormCreateEventWidget extends StatefulWidget {
  DateTime? start;
  CalendarFormCreateEventWidget({this.start, super.key});

  @override
  State<CalendarFormCreateEventWidget> createState() =>
      _CalendarFormCreateEventWidgetState();
}

class _CalendarFormCreateEventWidgetState
    extends State<CalendarFormCreateEventWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Column(children: [Text(widget.start.toString())]),
    );
  }
}
