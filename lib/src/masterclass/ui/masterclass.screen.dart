import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:recparenting/_shared/models/webpage_arguments.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/environments/env.dart';

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
      String url = '${env.web}masterclasses/';
      url = '${env.url}login-token?redirect_to=$url';
      Navigator.pushReplacementNamed(context, webPageRoute,
          arguments: WebpageArguments(
            url: url,
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
