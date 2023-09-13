import 'package:flutter/material.dart';
import 'package:recparenting/_shared/ui/app_submenu_item.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppSubmenuWidget extends StatelessWidget {
  const AppSubmenuWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SubmenuButton(
      alignmentOffset: const Offset(0, 8),
      menuStyle: const MenuStyle(
          backgroundColor: MaterialStatePropertyAll(colorRecDark)),
      menuChildren: [
        AppSubmenuItemWidget(
            onPress: () => Navigator.pushNamed(context, homeRoute),
            titleUrl: AppLocalizations.of(context)!.menuHome),
        AppSubmenuItemWidget(
            onPress: () => Navigator.pushNamed(context, chatPageRoute),
            titleUrl: AppLocalizations.of(context)!.menuChat)
      ],
      child: const Icon(Icons.more_vert, color: Colors.white),
    );
  }
}
