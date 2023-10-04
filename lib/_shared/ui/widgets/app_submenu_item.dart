import 'package:flutter/material.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/ui/widgets/title.widget.dart';

class AppSubmenuItemWidget extends StatelessWidget {
  final String titleUrl;
  final Function() onPress;
  const AppSubmenuItemWidget(
      {required this.titleUrl, required this.onPress, super.key});

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
      onPressed: onPress,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TitleDefault(titleUrl, color: TextColors.white),
        Icon(
          Icons.arrow_outward_outlined,
          size: 15,
          color: TextColors.white.color,
        )
      ]),
    );
  }
}
