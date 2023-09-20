import 'package:flutter/material.dart';
import 'package:recparenting/_shared/ui/widgets/notransition_builder.dart';
import 'package:recparenting/constants/colors.dart';

class RecThemeData {
  static ThemeData get lightTheme {
    return ThemeData(
        useMaterial3: true,
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            for (final platform in TargetPlatform.values)
              platform: const NoTransitionsBuilder(),
          },
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
        ),
        elevatedButtonTheme: const ElevatedButtonThemeData(
            style: ButtonStyle(
                foregroundColor: MaterialStatePropertyAll(Colors.white),
                backgroundColor: MaterialStatePropertyAll(colorRecLight))),
        textButtonTheme: const TextButtonThemeData(
            style: ButtonStyle(
                foregroundColor: MaterialStatePropertyAll(colorRecLight))),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            shape: CircleBorder(),
            backgroundColor: colorRecLight,
            foregroundColor: Colors.white),
        appBarTheme: const AppBarTheme(
          color: colorRecDark,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(fontSize: 18),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        tabBarTheme: const TabBarTheme(
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: UnderlineTabIndicator(
                // color for indicator (underline)
                borderSide: BorderSide(color: Colors.white))),
        drawerTheme: const DrawerThemeData(backgroundColor: colorRecDark),
        brightness: Brightness.light);
  }

  static ThemeData get darkTheme {
    return ThemeData(
        useMaterial3: true,
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            for (final platform in TargetPlatform.values)
              platform: const NoTransitionsBuilder(),
          },
        ),
        scaffoldBackgroundColor: Colors.black38,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 18, color: Colors.white),
        ),
        elevatedButtonTheme: const ElevatedButtonThemeData(
            style: ButtonStyle(
                foregroundColor: MaterialStatePropertyAll(Colors.white),
                backgroundColor: MaterialStatePropertyAll(colorRecLight))),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: colorRecLight, foregroundColor: Colors.white),
        textButtonTheme: const TextButtonThemeData(
            style: ButtonStyle(
                foregroundColor: MaterialStatePropertyAll(colorRecLight))),
        appBarTheme: const AppBarTheme(
          color: colorRecDark,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(fontSize: 18),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.white,
          indicatorColor: Colors.white,
        ),
        drawerTheme: const DrawerThemeData(backgroundColor: colorRecDark),
        brightness: Brightness.dark);
  }
}
