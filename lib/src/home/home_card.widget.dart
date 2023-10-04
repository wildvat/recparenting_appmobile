import 'package:flutter/material.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/models/text_sizes.enum.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
import 'package:recparenting/constants/colors.dart';

class HomeCardWidget extends StatelessWidget {
  final String text;
  final String pathImage;
  final TextColors colorText;
  final Color colorBack;
  final bool isExternalLink;
  final Function() onPress;

  const HomeCardWidget(
      {required this.text,
      required this.pathImage,
      required this.onPress,
      required this.colorText,
      required this.colorBack,
      this.isExternalLink = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPress,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/$pathImage.jpg'))),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              width: double.infinity,
              color: colorBack,
              child: Stack(
                children: [
                  Container(
                      padding: const EdgeInsets.all(5),
                      width: double.infinity,
                      child: TextDefault(
                        text,
                        size: TextSizes.large,
                        color: colorText,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                      )),
                  Positioned(
                    top: -3,
                    right: -3,
                    child: Icon(
                      Icons.arrow_outward_outlined,
                      size: 15,
                      color: colorText.color,
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
