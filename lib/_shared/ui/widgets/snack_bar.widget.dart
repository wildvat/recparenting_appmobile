import 'package:flutter/material.dart';

class SnackBarRec{
  final BuildContext context;
  final String message;
  Color backgroundColor = Colors.red;
  bool showCloseIcon = true;
  Duration duration = const Duration(seconds: 2);

  SnackBarRec({required this.context, required this.message, this.backgroundColor = Colors.red, this.showCloseIcon = true, this.duration = const Duration(seconds: 2)}){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: duration,
          elevation: 5,
          behavior: SnackBarBehavior.floating,
          backgroundColor: backgroundColor,
          content: Text(message.toString()),
          showCloseIcon: showCloseIcon
        ));
  }
  }