import 'package:flutter/material.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/navigator_key.dart';

import '../../providers/r_language.dart';

class SnackBarRec {
  final String message;
  Color backgroundColor = Colors.red;
  bool showCloseIcon = true;
  Duration duration = const Duration(seconds: 2);
  final Function()? onPress;

  SnackBarRec(
      {required this.message,
      this.backgroundColor = Colors.red,
      this.showCloseIcon = true,
      this.duration = const Duration(seconds: 2),
      this.onPress
      }
) {
    scaffoldKey.currentState?.showSnackBar(SnackBar(
        duration: duration,
        elevation: 5,
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor,
        content: Text(message.toString()),
        showCloseIcon: showCloseIcon,
        action: onPress!=null ? SnackBarAction(
          textColor: colorRecLight,
          label: R.string.generalShow,
          onPressed: () => onPress,
        ):null,
    ),

    );
  }
}
