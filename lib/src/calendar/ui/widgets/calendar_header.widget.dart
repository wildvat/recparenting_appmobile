import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:recparenting/constants/colors.dart';

class HeaderCalendarStyle extends HeaderStyle {
  const HeaderCalendarStyle(
      {super.decoration = const BoxDecoration(color: colorRecLight),
      super.headerTextStyle =
          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)});
}
