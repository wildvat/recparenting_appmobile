import 'package:flutter/material.dart';
import 'package:recparenting/constants/colors.dart';

import '../models/user.model.dart';

class AvatarImage extends StatefulWidget {
  final User user;
  late double size;
  AvatarImage({super.key, required this.user, this.size = 48});

  @override
  State<AvatarImage> createState() => _AvatarImageState();
}

class _AvatarImageState extends State<AvatarImage> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: Image.network(widget.user.avatar,
            fit: BoxFit.cover, width: widget.size,
            //extensions like .jpg, .png etc
            errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.account_circle,
              size: 48, color: colorRecLight);
        }));
  }
}
