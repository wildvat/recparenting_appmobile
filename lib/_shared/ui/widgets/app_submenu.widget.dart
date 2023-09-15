import 'package:flutter/material.dart';
import 'package:recparenting/_shared/models/webpage_arguments.dart';
import 'package:recparenting/_shared/ui/widgets/app_submenu_item.dart';
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
            titleUrl: AppLocalizations.of(context)!.menuProfile),
        AppSubmenuItemWidget(
            onPress: () async {
              await Navigator.pushReplacementNamed(context, webPageRoute,
                  arguments: WebpageArguments(
                      url: 'https://www.recparenting.com/privacy-policy/'));
              await Future.delayed(const Duration(milliseconds: 10));
              _menuController.close();
            },
            titleUrl: AppLocalizations.of(context)!.menuLegal),
        AppSubmenuItemWidget(
            onPress: () async {
              await Navigator.pushNamed(context, contactPageRoute);
              await Future.delayed(const Duration(milliseconds: 10));
              _menuController.close();
            },
            titleUrl: AppLocalizations.of(context)!.menuContact),
      ],
      child: const Icon(Icons.more_vert, color: Colors.white),
    );
  }
}
