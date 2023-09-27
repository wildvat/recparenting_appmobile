import 'package:flutter/material.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';

import '../../../../_shared/helpers/avatar_image.dart';
import '../../../../_shared/models/text_sizes.enum.dart';
import 'change_therapist_reason.dart';

class TherapistBioHeaderWidget extends StatefulWidget {
  const TherapistBioHeaderWidget({
    super.key,
    required Therapist therapist,
  }) : _therapist = therapist;

  final Therapist _therapist;

  @override
  State<TherapistBioHeaderWidget> createState() => _TherapistBioHeaderWidgetState();
}

class _TherapistBioHeaderWidgetState extends State<TherapistBioHeaderWidget> {



  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20),
      color: colorRecDark,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(500)),
              child: AvatarImage(user: widget._therapist),
            ),
          ),
          const SizedBox(height: 15),
          TextDefault(
            widget._therapist.getFullName(),
            size: TextSizes.large,
            color: TextColors.light,
          ),
          TextDefault(
            '${widget._therapist.data.years_practice} yearsPractice',
            size: TextSizes.small,
            color: TextColors.muted,
          ),
          const SizedBox(height: 15),
          ChangeTherapistReasonWidget(therapist: widget._therapist),
        ],
      ),
    );
  }
}
