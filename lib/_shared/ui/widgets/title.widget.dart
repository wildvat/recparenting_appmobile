import 'package:flutter/material.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/models/text_sizes.enum.dart';

enum TitleSize { normal, large }

class TitleDefault extends Text {
  final TextColors color;
  final TitleSize size;
  TitleDefault(super.text,
      {super.key,
      this.color = TextColors.rec,
      this.size = TitleSize.normal,
      super.textAlign})
      : super(
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: size == TitleSize.normal
                    ? TextSizes.large.size
                    : TextSizes.xlarge.size,
                color: color.color));
}
