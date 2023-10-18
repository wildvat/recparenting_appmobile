import 'package:flutter/material.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
import 'package:recparenting/_shared/ui/widgets/title.widget.dart';
import 'package:recparenting/navigator_key.dart';

import '../../providers/r_language.dart';

class AlertDialogRec {
  final String title;
  final String content;
  final Function() onConfirm;

  //final Array<TextButton> buttons;
  AlertDialogRec(
      {required this.title, required this.content, required this.onConfirm}) {
    showDialog<String>(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) =>
          AlertDialog(
            title: TitleDefault(title),
            content: TextDefault(content),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Colors.red.shade400)),
                child: TextDefault(
                    R.string.generalCancel, color: TextColors.white),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
                  },

                  child: TextDefault(R.string.generalContinue,
                      color: TextColors.recDark, fontWeight: FontWeight.bold)),
            ],
          ),
    );
  }

  call() {
    return showDialog<String>(
      context: scaffoldKey.currentContext!,
      builder: (BuildContext context) =>
          AlertDialog(
            title: const Text('AlertDialog Title'),
            content: const Text('AlertDialog description'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}
