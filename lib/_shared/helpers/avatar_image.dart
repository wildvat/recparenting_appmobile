import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../models/user.model.dart';

class AvatarImage extends StatefulWidget {
  final User user;

  const AvatarImage({Key? key, required this.user}) : super(key: key);

  @override
  State<AvatarImage> createState() => _AvatarImageState();
}

class _AvatarImageState extends State<AvatarImage> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: Image.network(widget.user.avatar, fit: BoxFit.cover, width: 70,
            //extensions like .jpg, .png etc
            errorBuilder: (context, error, stackTrace) {
          return SvgPicture.network(
            width: 70,
            fit: BoxFit.cover,
            widget.user.avatar, // for .svg extension
          );
        }));
  }
}
