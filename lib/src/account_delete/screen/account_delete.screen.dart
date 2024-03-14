import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
import 'package:recparenting/_shared/ui/widgets/title.widget.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/src/contact/providers/contact.provider.dart';

class AccountDeleteScreen extends StatefulWidget {
  const AccountDeleteScreen({super.key});

  @override
  State<AccountDeleteScreen> createState() => _AccountDeleteScreenState();
}

class _AccountDeleteScreenState extends State<AccountDeleteScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
        title: AppLocalizations.of(context)!.deleteAccountTitle,
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
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
                      AppLocalizations.of(context)!.deleteAccountText,
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
                    controller: _textEditingController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!
                            .generalFormRequired;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: TextColors.muted.color),
                      border: InputBorder.none,
                      hintText: AppLocalizations.of(context)!.chatEnterMessage,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    setState(() => _loading = true);
                    await ContactApi()
                        .requestDeleteAccount(_textEditingController.text);
                    setState(() => _loading = false);
                  },
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : TextDefault(AppLocalizations.of(context)!.generalSend),
                ),
              ],
            ),
          ),
        )));
  }
}
