import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:recparenting/_shared/models/webpage_arguments.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MasterclassScreen extends StatefulWidget {
  const MasterclassScreen({super.key});

  @override
  State<MasterclassScreen> createState() => _MasterclassScreenState();
}

class _MasterclassScreenState extends State<MasterclassScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, webPageRoute,
          arguments: WebpageArguments(
            url: 'https://www.recparenting.com/masterclasses/',
            title: AppLocalizations.of(context)!.menuMasterclasses,
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
        title: 'Masterclass',
        body: const Center(
          child: CircularProgressIndicator(),
        ));
  }
}
