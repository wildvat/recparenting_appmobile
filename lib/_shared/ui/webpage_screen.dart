import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/_shared/models/webpage_arguments.dart';
import 'package:recparenting/_shared/ui/widgets/web_viewer.widget.dart';

class WebPageScreen extends StatelessWidget {
  final WebpageArguments arguments;
  const WebPageScreen({required this.arguments, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              arguments.title ?? AppLocalizations.of(context)!.webPageTitle),
        ),
        body: WebViewerWidget(url: arguments.url));
  }
}
