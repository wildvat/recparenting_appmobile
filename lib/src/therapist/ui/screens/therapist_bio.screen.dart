import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';
import 'package:recparenting/src/therapist/ui/widgets/shared_chat_wit_therapist.dart';
import 'package:recparenting/src/therapist/ui/widgets/therapist_bio_header.dart';
import 'package:recparenting/src/therapist/ui/widgets/therapist_working_hours.dart';

class TherapistBioScreen extends StatefulWidget {
  final Therapist therapist;
  const TherapistBioScreen({ super.key, required this.therapist});

  @override
  State<TherapistBioScreen> createState() => _TherapistBioScreenState();
}

class _TherapistBioScreenState extends State<TherapistBioScreen> {

  @override
  void initState() {
    super.initState();
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
                          Text(widget.therapist.data.bio),
                          const Divider(height: 50),
                          SharedChatWithTherapistWidget(therapist: widget.therapist),
                          TherapistWorkingHours(widget.therapist),
                        ],
                      ),
                    )
                  ],
                ),
              )
           );
  }
}
