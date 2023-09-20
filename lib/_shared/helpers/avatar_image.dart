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
    return Image.network(widget.user.avatar,
        fit: BoxFit.cover,
        //extensions like .jpg, .png etc
        errorBuilder: (context, error, stackTrace) {
      return SvgPicture.network(
        fit: BoxFit.cover,
        widget.user.avatar, // for .svg extension
      );
    });
  }
}
