import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:recparenting/src/current_user/bloc/current_user_bloc.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';
import 'package:recparenting/src/therapist/ui/widgets/therapist_bio_header.dart';
import 'package:recparenting/src/therapist/ui/widgets/therapist_working_hours.dart';

class TherapistBioScreen extends StatefulWidget {
  const TherapistBioScreen({super.key});

  @override
  State<TherapistBioScreen> createState() => _TherapistBioScreenState();
}

class _TherapistBioScreenState extends State<TherapistBioScreen> {
  Therapist? _therapist;

  @override
  void initState() {
    super.initState();
    final Patient patient =
        ((context.read<CurrentUserBloc>().state as CurrentUserLoaded).user
            as Patient);
    if (patient.therapist != null) {
      _therapist = patient.therapist!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
        title: AppLocalizations.of(context)!.therapistBioTitle,
        body: _therapist != null
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    TherapistBioHeaderWidget(therapist: _therapist),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_therapist!.data.bio),
                          const Divider(height: 50),
                          TherapistWorkingHours(_therapist!),
                        ],
                      ),
                    )
                  ],
                ),
              )
            : const Center(
                child: Text('No tienes terapeuta, contacta con administración'),
              ));
  }
}
