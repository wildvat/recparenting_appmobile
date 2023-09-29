import 'package:flutter/material.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/models/text_sizes.enum.dart';

class TextDefault extends Text {
  final TextSizes? size;
  final FontWeight? fontWeight;
  final TextColors? color;
  final TextAlign? textAlign;
  TextDefault(super.text,
      {super.key, this.color, this.fontWeight, this.textAlign, this.size})
      : super(
            textAlign: textAlign,
            style: TextStyle(
                fontSize: size?.size ?? TextSizes.medium.size,
                fontWeight: fontWeight,
                color: color?.color));
}
