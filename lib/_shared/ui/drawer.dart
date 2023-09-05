import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:recparenting/_shared/ui/drawer.menu_item.dart';
import 'package:recparenting/_shared/ui/select_language.widget.dart';
import 'package:recparenting/constants/router_names.dart';

class DrawerApp extends StatefulWidget {
  const DrawerApp({Key? key}) : super(key: key);

  @override
  State<DrawerApp> createState() => _DrawerAppState();
}

class _DrawerAppState extends State<DrawerApp> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Drawer(
      child: Column(
        children: [
          Expanded(
              child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    )),
              ),
              DrawerMenuItem(
                title: AppLocalizations.of(context)!.menuHome,
                route: homeRoute,
              ),
            ],
          )),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {},
                  child: Text(
                    AppLocalizations.of(context)!.logout,
                  )),
              SelectLanguageWidget()
            ],
          )
        ],
      ),
    ));
  }
}
