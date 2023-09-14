import 'package:flutter/material.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
        title: AppLocalizations.of(context)!.menuContact,
        body: const Text('contact'));
  }
}
