import 'package:flutter/material.dart';
import 'package:recparenting/navigator_key.dart';

import '../../providers/r_language.dart';

class SnackBarRec {
  final String message;
  Color backgroundColor = Colors.red;
  bool showCloseIcon = true;
  Duration duration;
  final Function()? onPress;

  SnackBarRec(
      {required this.message,
      this.backgroundColor = Colors.red,
      this.showCloseIcon = true,
      this.duration = const Duration(seconds: 20),
      this.onPress
      }
) {
    scaffoldKey.currentState?.showSnackBar(SnackBar(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
        duration: duration,
        elevation: 5,
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor,
        content: Text(message.toString()),
        showCloseIcon: showCloseIcon,
        action: onPress!=null ? SnackBarAction(
          textColor: Colors.black,
          label: R.string.generalShow,
          onPressed: onPress!,
        ):null,
    ),

    );
  }
}
