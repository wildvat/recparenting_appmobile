import 'package:flutter/material.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/models/text_sizes.enum.dart';
import 'package:recparenting/_shared/ui/widgets/notransition_builder.dart';
import 'package:recparenting/constants/colors.dart';

class RecThemeData {
  static ThemeData get lightTheme {
    return ThemeData(
            useMaterial3: true,
            fontFamily: 'ProximaSoft',
            //colorScheme: ColorScheme(brightness: Brightness.light, primary: colorRec, onPrimary: Colors.white, secondary: colorRecLight, onSecondary: colorRecDark)
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                for (final platform in TargetPlatform.values)
                  platform: const NoTransitionsBuilder(),
              },
            ),
            textSelectionTheme:
                const TextSelectionThemeData(cursorColor: colorRecLight),
            textTheme: const TextTheme(
              displayLarge:
                  TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            inputDecorationTheme: InputDecorationTheme(
                enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                        style: BorderStyle.solid, color: colorRecLight)),
                focusColor: colorRecLight,
                focusedBorder: const UnderlineInputBorder(
                  borderSide:
                      BorderSide(style: BorderStyle.solid, color: colorRecDark),
                ),
                activeIndicatorBorder: const BorderSide(color: colorRecLight),
                hintStyle: TextStyle(
                    color: TextColors.muted.color,
                    fontSize: TextSizes.small.size),
                labelStyle: const TextStyle(color: colorRecDark),
                border: const UnderlineInputBorder(
                    borderSide: BorderSide(
                        style: BorderStyle.solid, color: colorRecLight))),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                    textStyle: MaterialStatePropertyAll<TextStyle>(TextStyle(
                        fontSize: TextSizes.small.size,
                        fontWeight: FontWeight.bold)),
                    foregroundColor:
                        const MaterialStatePropertyAll(Colors.white),
                    backgroundColor:
                        const MaterialStatePropertyAll(colorRecLight))),
            textButtonTheme: const TextButtonThemeData(
                style: ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(colorRecLight))),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
                shape: CircleBorder(),
                backgroundColor: colorRecLight,
                foregroundColor: Colors.white),
            appBarTheme: AppBarTheme(
              color: colorRecDark,
              foregroundColor: Colors.white,
              titleTextStyle: TextStyle(
                  fontSize: TextSizes.large.size, fontWeight: FontWeight.bold),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            tabBarTheme: const TabBarTheme(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white24,
                indicatorColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: UnderlineTabIndicator(
                    // color for indicator (underline)
                    borderSide: BorderSide(color: Colors.white))),
            drawerTheme: const DrawerThemeData(backgroundColor: colorRecDark),
            brightness: Brightness.light)
        .copyWith(
            colorScheme: ThemeData()
                .colorScheme
                .copyWith(primary: colorRecLight, onPrimary: Colors.black));
  }

  static ThemeData get darkTheme {
    return ThemeData(
        useMaterial3: true,
        fontFamily: 'ProximaSoft',
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
        appBarTheme: AppBarTheme(
          color: colorRecDark,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
              color: Colors.red,
              fontSize: TextSizes.large.size,
              fontWeight: FontWeight.bold),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.white,
          indicatorColor: Colors.white,
        ),
        drawerTheme: const DrawerThemeData(backgroundColor: colorRecDark),
        brightness: Brightness.dark);
  }
}
