import 'package:flutter/material.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
        title: AppLocalizations.of(context)!.menuContact,
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    minLines: 6,
                    maxLines: 6,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.chatEnterMessage,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      //todo add functionality
                    },
                    child: Text(AppLocalizations.of(context)!.generalSend),
                  ),
                ],
              ),
            ),
          ),
        )));
  }
}
