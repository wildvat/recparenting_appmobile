import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
import 'package:recparenting/_shared/ui/widgets/title.widget.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/src/auth/providers/login.provider.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailEditingController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
/*
    if(_currentUserBloc.state is CurrentUserLoaded){
      Navigator.pushReplacementNamed(context, homeRoute);
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: colorRec,
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SvgPicture.asset(
              'assets/images/rec-logo-inverse.svg',
              width: 80,
            ),
            Padding(
                padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TitleDefault(
                          AppLocalizations.of(context)!.passwordRecoveryTitle,
                          color: TextColors.white),
                      TextFormField(
                        controller: _emailEditingController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .generalFormErrorEmail;
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          hintText: AppLocalizations.of(context)!.generalEmail,
                          hintStyle: const TextStyle(color: Colors.white60),
                        ),
                      ),
                      const SizedBox(height: 40),
                      _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                //todo send
                                setState(() {
                                  _isLoading = true;
                                });
                                await AuthApi().passwordRecovery(
                                    email: _emailEditingController.text);
                                setState(() {
                                  _isLoading = false;
                                });
                              },
                              child: SizedBox(
                                  width: double.infinity,
                                  child: TextDefault(
                                    AppLocalizations.of(context)!.generalAccess,
                                    textAlign: TextAlign.center,
                                  ))),
                    ],
                  ),
                ))
          ]),
        ));
  }
}
