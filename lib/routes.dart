import 'package:flutter/material.dart';
import 'package:recparenting/_shared/models/webpage_arguments.dart';
import 'package:recparenting/_shared/ui/webpage_screen.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:recparenting/splash_screen.dart';
import 'package:recparenting/src/auth/ui/login.screen.dart';
import 'package:recparenting/src/room/ui/screens/chat.screen.dart';
import 'package:recparenting/src/home/ui/home.screen.dart';

class RouterRec {
  static Map<String, Widget Function(BuildContext)> routes = {
    homeRoute: (_) => const HomePage(),
    splashRoute: (_) => const SplashScreen(),
    loginRoute: (_) => const LoginScreen(),
    webPageRoute: (context) {
      final WebpageArguments argument =
          ModalRoute.of(context)!.settings.arguments as WebpageArguments;
      return WebPageScreen(arguments: argument);
    },
    chatPageRoute: (_) => const ChatScreen(),
    /*
    newsListRoute: (_) => const NewsListScreen(),
    newsSingleRoute: (BuildContext context) {
      final NewsSingle news =
          ModalRoute.of(context)!.settings.arguments as NewsSingle;
      return NewsScreen(news);
    },
    webPageRoute: (context) {
      final WebpageArguments argument =
          ModalRoute.of(context)!.settings.arguments as WebpageArguments;
      return WebPageScreen(arguments: argument);
    },
    calendarRoute: (_) => const CalendarScreen(),
    eventRoute: (context) {
      final CalendarModel argument =
          ModalRoute.of(context)!.settings.arguments as CalendarModel;
      return EventScreen(event: argument);
    },
    reportListRoute: (_) => const ReportsScreen(),
    reportSingleRoute: (context) {
      final ReportModel argument =
          ModalRoute.of(context)!.settings.arguments as ReportModel;
      return ResportScreen(report: argument);
    },
    offerListRoute: (_) => const OffersScreen(),
    offerSingleRoute: (context) {
      final OfferModel argument =
          ModalRoute.of(context)!.settings.arguments as OfferModel;
      return OfferScreen(offer: argument);
    },
    messagesRoute: (context) {
      final Folders? folder =
          ModalRoute.of(context)!.settings.arguments as Folders?;
      return MessagesScreen(folder: folder);
    },
    messageRoute: (context) {
      final Message argument =
          ModalRoute.of(context)!.settings.arguments as Message;
      return MessageScreen(message: argument);
    },
    selectUsersRoute: (_) => const UsersSelectScreen(),
    grantsRoute: (_) => const GrantsScreen(),
    loginRoute: (_) => const LoginScreen(),
    splashRoute: (_) => const SplashScreen(),
    */
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
        builder: (context) => const Scaffold(
                body: Center(
              child: Text('Página no encontrada'),
            )));
  }
}
