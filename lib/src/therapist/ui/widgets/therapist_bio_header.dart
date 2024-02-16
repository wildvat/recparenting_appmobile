import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
import 'package:recparenting/_shared/ui/widgets/title.widget.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';

import '../../../../_shared/helpers/avatar_image.dart';
import 'change_therapist_reason.dart';

class TherapistBioHeaderWidget extends StatelessWidget {
  const TherapistBioHeaderWidget({
    super.key,
    required Therapist therapist,
  }) : _therapist = therapist;

  final Therapist _therapist;

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
              child: AvatarImage(user: _therapist),
            ),
          ),
          const SizedBox(height: 15),
          TitleDefault(
            _therapist.getFullName(),
            size: TitleSize.large,
            color: TextColors.white,
            textAlign: TextAlign.center,
          ),
          TextDefault(
            AppLocalizations.of(context)!
                .therapistYears(_therapist.data.years_practice),
            color: TextColors.muted,
          ),
          const SizedBox(height: 15),
          ChangeTherapistReasonWidget(therapist: _therapist),
        ],
      ),
    );
  }
}
