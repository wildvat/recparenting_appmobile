import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:recparenting/src/auth/providers/login.provider.dart';

import '../../../_shared/helpers/push_permision.dart';
import '../../../_shared/models/user.model.dart';
import '../../../_shared/ui/widgets/snack_bar.widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
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
    //TODO para ahorrame meter la contraseña en el login
    /*
    Therapist:
    melyna.kreiger@example.com
    password
    ----
    Patient
    madelynn97@example.com
    password
    */
    _emailEditingController.text = 'melyna.kreiger@example.com';
    //_emailEditingController.text = 'madelynn97@example.com';
    _passwordEditingController.text = 'password';
    return Scaffold(
        backgroundColor: colorRec,
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SvgPicture.asset(
              'assets/images/rec-logo-inverse.svg',
              width: 80,
            ),
            Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _emailEditingController,
                        keyboardType: TextInputType.emailAddress,

                        // The validator receives the text that the user has entered.
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
                      const SizedBox(height: 10),
                      TextFormField(
                          controller: _passwordEditingController,
                          obscureText: true,
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor introduzca una contraseña';
                            }
                            return null;
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            hintText:
                                AppLocalizations.of(context)!.generalPassword,
                            hintStyle: const TextStyle(color: Colors.white60),
                          )),
                      const SizedBox(height: 30),
                      _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                User? response = await AuthApi().login(
                                    email: _emailEditingController.text,
                                    password: _passwordEditingController.text);
                                setState(() {
                                  _isLoading = false;
                                });
                                if (!mounted) return;
                                if (response != null) {
                                  getPermissionPushApp();
                                  Navigator.pushReplacementNamed(
                                      context, homeRoute);
                                  return;
                                } else {
                                  SnackBarRec(
                                      message: AppLocalizations.of(context)!
                                          .generalFormLoginError);
                                }
                              },
                              child: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    AppLocalizations.of(context)!.generalAccess,
                                    textAlign: TextAlign.center,
                                  ))),
                      const SizedBox(height: 10),
                      TextButton(
                          onPressed: () => Navigator.pushNamed(
                              context, passwordRecoveryRoute),
                          child: Text(
                              AppLocalizations.of(context)!.recoveryPassLinnk))
                    ],
                  ),
                ))
          ]),
        ));
  }
}
