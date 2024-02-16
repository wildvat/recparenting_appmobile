import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/models/text_sizes.enum.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
import 'package:recparenting/_shared/ui/widgets/title.widget.dart';
import 'package:recparenting/constants/colors.dart';

import 'package:recparenting/src/therapist/models/therapist.model.dart';
import 'package:recparenting/src/therapist/models/working-hours.model.dart';

class TherapistWorkingHours extends StatefulWidget {
  final Therapist therapist;
  const TherapistWorkingHours(this.therapist, {super.key});

  @override
  State<TherapistWorkingHours> createState() => _TherapistWorkingHoursState();
}

class _TherapistWorkingHoursState extends State<TherapistWorkingHours> {
  late List _workingHours;

  @override
  void initState() {
    super.initState();
    _workingHours = widget.therapist.data.working_hours.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TitleDefault(
          AppLocalizations.of(context)!.workingHoursTitle,
          size: TitleSize.large,
        ),
        const SizedBox(height: 10),
        _workingHours.isEmpty
            ? const SizedBox.shrink()
            : ListView.separated(
                shrinkWrap: true,
                itemCount: _workingHours.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                      height: 20,
                      color: colorRecLight,
                    ),
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        width: 120,
                        child: TextDefault(
                          AppLocalizations.of(context)!
                              .getDay(_workingHours[index]['day'])
                              .toUpperCase(),
                          color: TextColors.recLight,
                          fontWeight: FontWeight.bold,
                          size: TextSizes.large,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: (_workingHours[index]['startEnd']
                                    as WorkingHoursStartEndList)
                                .hours
                                .length,
                            itemBuilder: (BuildContext context, int indexWh) {
                              return TextDefault(
                                '${(_workingHours[index]['startEnd'] as WorkingHoursStartEndList).hours[indexWh]!.start} - ${(_workingHours[index]['startEnd'] as WorkingHoursStartEndList).hours[indexWh]!.end}',
                                size: TextSizes.large,
                              );
                            }),
                      )
                    ],
                  );
                }),
      ],
    );
  }
}
