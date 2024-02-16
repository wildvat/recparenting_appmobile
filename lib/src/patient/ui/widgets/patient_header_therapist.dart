import 'package:flutter/material.dart';
import 'package:recparenting/_shared/helpers/avatar_image.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/ui/widgets/title.widget.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';

class PatientHeaderTherapist extends StatelessWidget {
  final Therapist therapist;
  const PatientHeaderTherapist({required this.therapist, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.pushNamed(context, therapistBioPageRoute,
            arguments: therapist),
        child: Container(
            height: 170,
            decoration: const BoxDecoration(
              color: colorRecDark,
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    minRadius: 50.0,
                    child: AvatarImage(
                      user: therapist,
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TitleDefault(therapist.name,
                      size: TitleSize.large, color: TextColors.white)
                ])));
  }
}
