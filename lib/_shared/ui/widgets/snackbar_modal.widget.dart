import 'package:flutter/material.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/models/text_sizes.enum.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';

class SnackbarModal extends StatefulWidget {
  final String title;
  final Color backgroundColor;
  const SnackbarModal(
      {required this.title, required this.backgroundColor, super.key});

  @override
  State<SnackbarModal> createState() => _SnackbarModalState();
}

class _SnackbarModalState extends State<SnackbarModal> {
  bool _removed = false;

  @override
  Widget build(BuildContext context) {
    return _removed
        ? const SizedBox.shrink()
        : Container(
            width: double.infinity,
            color: widget.backgroundColor,
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextDefault(
                  widget.title,
                  color: TextColors.white,
                  size: TextSizes.small,
                ),
                GestureDetector(
                    onTap: () => setState(() {
                          _removed = true;
                        }),
                    child: const Icon(
                      Icons.close,
                      size: 15,
                      color: Colors.white70,
                    ))
              ],
            ));
  }
}
