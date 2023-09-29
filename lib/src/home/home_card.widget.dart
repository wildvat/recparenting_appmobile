import 'package:flutter/material.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/models/text_sizes.enum.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';

class HomeCardWidget extends StatelessWidget {
  final String text;
  final String pathImage;
  final Function() onPress;

  const HomeCardWidget(
      {required this.text,
      required this.pathImage,
      required this.onPress,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPress,
        child: Container(
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/$pathImage.jpg'))),
          child: Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            color: Colors.black.withOpacity(0.5),
            child: TextDefault(
              text,
              size: TextSizes.medium,
              color: TextColors.white,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
          ),
        ));
  }
}
