import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/_shared/models/text_sizes.enum.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:recparenting/_shared/ui/widgets/title.widget.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';
import 'package:recparenting/src/therapist/ui/widgets/shared_chat_wit_therapist.dart';
import 'package:recparenting/src/therapist/ui/widgets/therapist_bio_header.dart';
import 'package:recparenting/src/therapist/ui/widgets/therapist_working_hours.dart';

import '../../../../_shared/models/text_colors.enum.dart';
import '../../../../_shared/ui/widgets/text.widget.dart';

class TherapistBioScreen extends StatefulWidget {
  final Therapist therapist;

  const TherapistBioScreen({super.key, required this.therapist});

  @override
  State<TherapistBioScreen> createState() => _TherapistBioScreenState();
}

class _TherapistBioScreenState extends State<TherapistBioScreen> {
  @override
  void initState() {
    super.initState();
  }

  Widget getAreasExpertise() {
    Widget title = TitleDefault(
        AppLocalizations.of(context)!.therapistAreasExpertiseTitle,
        size: TitleSize.large);
    List<Widget> widgets = [];
    for (var value in widget.therapist.data.areas_expertise) {
      widgets.add(Chip(
          backgroundColor: colorRecLight,
          label: TextDefault(
            AppLocalizations.of(context)!.therapistAreasExpertise(value.name),
            size: TextSizes.medium,
            color: TextColors.white,
          )));
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [title, const SizedBox(height: 10), Wrap(children: widgets)]);
  }

  Widget getOtherData() {
    List<Widget> widgets = [];
    widgets.add(TitleDefault(
        AppLocalizations.of(context)!.therapistOtherDataTitle,
        size: TitleSize.large));
    widgets.add(const SizedBox(height: 10));
    widgets.add(Row(
      children: [
        TextDefault(
          AppLocalizations.of(context)!.generalReligionTitle,
          fontWeight: FontWeight.bold,
          size: TextSizes.large,
          color: TextColors.recLight,
        ),
        const SizedBox(width: 10),
        TextDefault(
          AppLocalizations.of(context)!
              .generalReligion(widget.therapist.data.religion.name),
          size: TextSizes.large,
        )
      ],
    ));
    widgets.add(const SizedBox(height: 10));
    widgets.add(Row(
      children: [
        TextDefault(
          AppLocalizations.of(context)!.generalGenderTitle,
          fontWeight: FontWeight.bold,
          size: TextSizes.large,
          color: TextColors.recLight,
        ),
        const SizedBox(width: 10),
        TextDefault(
          AppLocalizations.of(context)!
              .generalGender(widget.therapist.data.gender.name),
          size: TextSizes.large,
        )
      ],
    ));
    widgets.add(const SizedBox(height: 10));

    List<Widget> languages = [];
    for (var value in widget.therapist.data.language) {
      languages.add(TextDefault(
          AppLocalizations.of(context)!.generalLanguage(value.name),
          size: TextSizes.large));
    }
    widgets.add(Row(children: [
      TextDefault(AppLocalizations.of(context)!.generalLanguageTitle,
          fontWeight: FontWeight.bold,
          size: TextSizes.large,
          color: TextColors.recLight),
      const SizedBox(width: 10),
      Wrap(children: languages)
    ]));

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: widgets);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
        title: AppLocalizations.of(context)!.therapistBioTitle,
        body: SingleChildScrollView(
          child: Column(
            children: [
              TherapistBioHeaderWidget(therapist: widget.therapist),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 40, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextDefault(
                      widget.therapist.data.bio,
                      size: TextSizes.large,
                    ),
                    const Divider(height: 30),
                    SharedChatWithTherapistWidget(therapist: widget.therapist),
                    getAreasExpertise(),
                    const Divider(height: 30),
                    getOtherData(),
                    const Divider(height: 30),
                    TherapistWorkingHours(widget.therapist),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
