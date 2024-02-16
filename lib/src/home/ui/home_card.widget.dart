import 'package:flutter/material.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/models/text_sizes.enum.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';

class HomeCardWidget extends StatelessWidget {
  final String text;
  final double? width;
  final double? height;
  final String? pathImage;
  final TextColors colorText;
  final Color colorBack;
  final bool isExternalLink;
  final Function() onPress;
  double? _widthMedia;

  HomeCardWidget(
      {required this.text,
      this.pathImage,
      this.width,
      this.height,
      required this.onPress,
      required this.colorText,
      required this.colorBack,
      this.isExternalLink = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    if (width == null && pathImage != null) {
      _widthMedia = (MediaQuery.of(context).size.width / 2) - 40;
    }

    return GestureDetector(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          children: [
            pathImage != null
                ? Container(
                    width: width == null && pathImage != null
                        ? _widthMedia
                        : width,
                    height: height == null && pathImage != null
                        ? (_widthMedia ?? 0) * 1.35
                        : height,
                    clipBehavior: Clip.antiAlias,
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/$pathImage.jpg'))))
                : const SizedBox.shrink(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              width: _widthMedia,
              decoration: BoxDecoration(
                  color: colorBack,
                  borderRadius: (pathImage == null)
                      ? BorderRadius.circular(15)
                      : const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        )),
              child: Stack(
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 8),
                      width: double.infinity,
                      child: TextDefault(
                        text,
                        size: TextSizes.large,
                        color: colorText,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                      )),
                  isExternalLink
                      ? Positioned(
                          top: 0,
                          right: 0,
                          child: Icon(
                            Icons.arrow_outward_outlined,
                            size: 15,
                            color: colorText.color,
                          ),
                        )
                      : const SizedBox.shrink()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
