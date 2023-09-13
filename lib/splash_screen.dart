import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:recparenting/src/current_user/current_user.provider.dart';
import 'package:recparenting/src/current_user/current_user.repository.dart';
import 'dart:developer' as developer;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
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
      }).catchError((onError) {
        FlutterNativeSplash.remove();

        developer.log('SplashScreen Error 1 ${onError.toString()}');
        return Navigator.pushReplacementNamed(context, loginRoute);
      });
    } catch (error) {
      FlutterNativeSplash.remove();
      developer.log('SplashScreen Error 2 ${error.toString()}');
      return Navigator.pushReplacementNamed(context, loginRoute);
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
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }
}
