import 'package:flutter/material.dart';

class AppSubmenuItemWidget extends StatelessWidget {
  final String titleUrl;
  final Function() onPress;
  const AppSubmenuItemWidget(
      {required this.titleUrl, required this.onPress, super.key});

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
      onPressed: onPress,
      child: Text(titleUrl,
          style: const TextStyle(color: Colors.white, fontSize: 14)),
    );
  }
}
