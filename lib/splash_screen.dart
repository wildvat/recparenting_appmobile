import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/constants/router_names.dart';
import 'dart:developer' as developer;

import 'package:recparenting/src/current_user/providers/current_user.provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState({Key? key}) => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late User currentUser;

  _checkUser() {
    try {
      CurrentUserApi().getUser().then((User? userApi) async {
        FlutterNativeSplash.remove();
        if (userApi != null) {
          if (userApi.isActive()) {
            return Navigator.pushReplacementNamed(context, homeRoute);
          } else {
            return Navigator.pushReplacementNamed(context, loginRoute);
          }
        }
        return false;
      }, onError: (e) {
        developer.log('OnErrro ${e.toString()}');
        return false;
      }).catchError((onError) {
        FlutterNativeSplash.remove();
        developer.log('SplashScreen Error 1 ${onError.toString()}');
        return Navigator.pushReplacementNamed(context, loginRoute);
      });
    } catch (error) {
      FlutterNativeSplash.remove();
      developer.log('SplashScreen Error 2 ${error.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: colorRecDark,
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ));
  }
}
