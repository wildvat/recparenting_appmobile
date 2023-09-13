import 'package:flutter/material.dart';
import 'package:recparenting/_shared/ui/app_submenu_item.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/src/current_user/ui/profile.widget.dart';

class AppSubmenuWidget extends StatefulWidget {
  const AppSubmenuWidget({
    super.key,
  });

  @override
  State<AppSubmenuWidget> createState() => _AppSubmenuWidgetState();
}

class _AppSubmenuWidgetState extends State<AppSubmenuWidget> {
  final MenuController _menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    return SubmenuButton(
      controller: _menuController,
      alignmentOffset: const Offset(0, 8),
      menuStyle: const MenuStyle(
          backgroundColor: MaterialStatePropertyAll(colorRecDark)),
      menuChildren: [
        AppSubmenuItemWidget(
            onPress: () async {
              await Navigator.pushNamed(context, homeRoute);
              await Future.delayed(const Duration(milliseconds: 10));
              _menuController.close();
            },
            titleUrl: AppLocalizations.of(context)!.menuHome),
        AppSubmenuItemWidget(
            onPress: () async {
              await Navigator.pushNamed(context, chatPageRoute);
              await Future.delayed(const Duration(milliseconds: 10));
              _menuController.close();
            },
            titleUrl: AppLocalizations.of(context)!.menuChat),
        AppSubmenuItemWidget(
            onPress: () async {
              if (mounted) {
                await showModalBottomSheet(
                    useRootNavigator: true,
                    context: context,
                    builder: (context) {
                      return const ProfileWidget();
                    });
                await Future.delayed(const Duration(milliseconds: 10));
                _menuController.close();
              }
            },
            titleUrl: AppLocalizations.of(context)!.menuProfile)
      ],
      child: const Icon(Icons.more_vert, color: Colors.white),
    );
  }
}
