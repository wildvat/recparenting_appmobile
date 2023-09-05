import 'package:flutter/material.dart';
import 'package:recparenting/constants/colors.dart';

class RecThemeData {
  static ThemeData get lightTheme {
    return ThemeData(
        useMaterial3: true,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
        ),
        textButtonTheme: const TextButtonThemeData(
            style: ButtonStyle(
                foregroundColor: MaterialStatePropertyAll(colorRecLight))),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: colorRecLight, foregroundColor: Colors.white),
        appBarTheme: const AppBarTheme(
          color: colorRecDark,
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        drawerTheme: const DrawerThemeData(backgroundColor: colorRecDark),
        brightness: Brightness.light);
  }

  static ThemeData get darkTheme {
    return ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black38,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 18, color: Colors.white),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: colorRecLight, foregroundColor: Colors.white),
        appBarTheme: const AppBarTheme(
          color: colorRecDark,
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        drawerTheme: const DrawerThemeData(backgroundColor: colorRecDark),
        brightness: Brightness.dark);
  }
}
