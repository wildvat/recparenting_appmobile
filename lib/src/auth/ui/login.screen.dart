import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/models/webpage_arguments.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
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
    return Scaffold(
        backgroundColor: colorRec,
        body: Container(
            decoration: const BoxDecoration(
                color: Colors.black26,
                image: DecorationImage(
                    image: AssetImage('assets/images/home.jpg'),
                    fit: BoxFit.cover)),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/rec-logo-inverse.svg',
                      width: 80,
                    ),
                    Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 20, right: 20),
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
                                  fillColor: Colors.black26,
                                  filled: true,
                                  enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  hintText: AppLocalizations.of(context)!
                                      .generalEmail,
                                  hintStyle:
                                      const TextStyle(color: Colors.white60),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                  controller: _passwordEditingController,
                                  obscureText: true,
                                  // The validator receives the text that the user has entered.
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppLocalizations.of(context)!
                                          .generalFormRequired;
                                    }
                                    return null;
                                  },
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    fillColor: Colors.black26,
                                    filled: true,
                                    enabledBorder: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    hintText: AppLocalizations.of(context)!
                                        .generalPassword,
                                    hintStyle:
                                        const TextStyle(color: Colors.white60),
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
                                            password: _passwordEditingController
                                                .text);
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        if (!mounted) return;
                                        if (response != null) {
                                          getPermissionPushApp();
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              homeRoute,
                                              (Route<dynamic> route) => false);
                                          return;
                                        } else {
                                          SnackBarRec(
                                              message:
                                                  AppLocalizations.of(context)!
                                                      .generalFormLoginError);
                                        }
                                      },
                                      child: SizedBox(
                                          width: double.infinity,
                                          child: TextDefault(
                                            AppLocalizations.of(context)!
                                                .generalAccess,
                                            textAlign: TextAlign.center,
                                          ))),
                              const SizedBox(height: 10),
                              TextButton(
                                  onPressed: () => Navigator.pushNamed(
                                      context, webPageRoute,
                                      arguments: WebpageArguments(
                                          url:
                                              'https://app.recparenting.com/password/reset',
                                          title: AppLocalizations.of(context)!
                                              .recoveryPassLinnk)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextDefault(
                                        AppLocalizations.of(context)!
                                            .recoveryPassLinnk,
                                        color: TextColors.white,
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(left: 1, bottom: 8),
                                        child: Icon(
                                          Icons.arrow_outward_outlined,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  )),
                              TextButton(
                                  onPressed: () => Navigator.pushNamed(
                                      context, selectPlanRoute),
                                  child: TextDefault(
                                    AppLocalizations.of(context)!
                                        .generateAccountLink,
                                    textAlign: TextAlign.center,
                                    color: TextColors.white,
                                  ))
                            ],
                          ),
                        ))
                  ]),
            )));
  }
}
