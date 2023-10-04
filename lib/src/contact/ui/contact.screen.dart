import 'package:flutter/material.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/_shared/ui/widgets/title.widget.dart';
import 'package:recparenting/constants/colors.dart';

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.edit_note,
                      color: colorRec,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    TitleDefault(
                      AppLocalizations.of(context)!.chatEnterMessage,
                      size: TitleSize.large,
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: TextColors.light.color),
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                    minLines: 8,
                    maxLines: 8,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: TextColors.muted.color),
                      border: InputBorder.none,
                      hintText: AppLocalizations.of(context)!.chatEnterMessage,
                    ),
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
        )));
  }
}
