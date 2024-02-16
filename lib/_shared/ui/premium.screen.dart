import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
import 'package:recparenting/_shared/ui/widgets/title.widget.dart';
import 'package:recparenting/constants/router_names.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
      title: AppLocalizations.of(context)!.premiumTitle,
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TitleDefault(AppLocalizations.of(context)!.premiumText),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, contactPageRoute),
                  child: TextDefault(
                      AppLocalizations.of(context)!.generalButtonMoreInfo))
            ],
          )),
    );
  }
}
