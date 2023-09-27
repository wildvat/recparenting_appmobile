import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/_shared/models/text_sizes.enum.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';
import 'package:recparenting/src/therapist/ui/widgets/shared_chat_wit_therapist.dart';
import 'package:recparenting/src/therapist/ui/widgets/therapist_bio_header.dart';
import 'package:recparenting/src/therapist/ui/widgets/therapist_working_hours.dart';

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
    Widget title =
        TextDefault(AppLocalizations.of(context)!.therapistAreasExpertiseTitle,
          size: TextSizes.large,
          fontWeight: FontWeight.bold
        );
    List<Widget> widgets = [];
    for (var value in widget.therapist.data.areas_expertise) {
      widgets.add(Chip(
          backgroundColor: colorRecLight,
          label: TextDefault(AppLocalizations.of(context)!
              .therapistAreasExpertise(value.name))));
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          const SizedBox(height: 10),
          Wrap(children: widgets)
        ]);
  }

  Widget getOtherData(){
    List<Widget> widgets = [];
    widgets.add(TextDefault(AppLocalizations.of(context)!.therapistOtherDataTitle,
        size: TextSizes.large,
        fontWeight: FontWeight.bold
    ));
    widgets.add(TextDefault(AppLocalizations.of(context)!.generalGender,
        size: TextSizes.large,
        fontWeight: FontWeight.bold
    ));
    widgets.add(TextDefault(widget.therapist.data.gender,
        size: TextSizes.large,
        fontWeight: FontWeight.bold
    ));
    widgets.add(TextDefault(AppLocalizations.of(context)!.generalLanguage,
        size: TextSizes.large,
        fontWeight: FontWeight.bold
    ));
    for(var language in widget.therapist.data.language){
      widgets.add(TextDefault(language));
    }

    if(widget.therapist.data.religion.isNotEmpty){
      widgets.add(TextDefault(AppLocalizations.of(context)!.generalReligion,
          size: TextSizes.large,
          fontWeight: FontWeight.bold
      ));
      widgets.add(TextDefault(widget.therapist.data.religion));
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets);
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
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextDefault(widget.therapist.data.bio),
                    const Divider(height: 50),
                    SharedChatWithTherapistWidget(therapist: widget.therapist),
                    const Divider(height: 50),
                    getAreasExpertise(),
                    const Divider(height: 50),
                    getOtherData(),
                    const Divider(height: 50),
                    TherapistWorkingHours(widget.therapist),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
