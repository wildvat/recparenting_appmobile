import 'package:flutter/material.dart';
import 'package:recparenting/constants/colors.dart';

enum TextColors {
  dark,
  white,
  light,
  muted,
  rec,
  recLight,
  recDark,
  chat,
  chatDark,
  masterclass,
  masterclassDark,
  danger,
  warning,
  success;

  Color get color {
    switch (this) {
      case TextColors.dark:
        return Colors.black87;
      case TextColors.white:
        return Colors.white;
      case TextColors.light:
        return Colors.grey.shade300;
      case TextColors.muted:
        return Colors.grey.shade500;
      case TextColors.rec:
        return colorRec;
      case TextColors.recLight:
        return colorRecLight;
      case TextColors.recDark:
        return colorRecDark;
      case TextColors.chat:
        return colorChat;
      case TextColors.chatDark:
        return const Color(0xff453A12);
      case TextColors.masterclass:
        return colorMasterclass;
      case TextColors.masterclassDark:
        return const Color(0xff006269);
      case TextColors.danger:
        return Colors.red;
      case TextColors.success:
        return Colors.green;
      case TextColors.warning:
        return Colors.orange;
      default:
        return Colors.black87;
    }
  }
}
