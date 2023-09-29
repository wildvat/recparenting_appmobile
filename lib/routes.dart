import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:recparenting/_shared/models/webpage_arguments.dart';
import 'package:recparenting/_shared/ui/premium.screen.dart';
import 'package:recparenting/_shared/ui/webpage_screen.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:recparenting/splash_screen.dart';
import 'package:recparenting/src/auth/ui/login.screen.dart';
import 'package:recparenting/src/auth/ui/pasword_recovery.dart';
import 'package:recparenting/src/calendar/ui/screens/calendar.screen.dart';
import 'package:recparenting/src/conference/provider/join_meeting_provider.dart';
import 'package:recparenting/src/conference/provider/meeting_provider.dart';
import 'package:recparenting/src/conference/provider/method_channel_coordinator.dart';
import 'package:recparenting/src/conference/ui/join_meeting.screen.dart';
import 'package:recparenting/src/contact/ui/contact.screen.dart';
import 'package:recparenting/src/conference/ui/conference.screen.dart';
import 'package:recparenting/src/forum/bloc/forum_bloc.dart';
import 'package:recparenting/src/forum/models/thread.model.dart';
import 'package:recparenting/src/forum/ui/screens/forums.screen.dart';
import 'package:recparenting/src/forum/ui/screens/thread.screen.dart';
import 'package:recparenting/src/masterclass/ui/masterclass.screen.dart';
import 'package:recparenting/src/notifications/ui/screens/notifications_list.screen.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/patient/ui/screens/patient_show.screen.dart';
import 'package:recparenting/src/patient/ui/screens/patients_list.screen.dart';
import 'package:recparenting/src/podcast/ui/podcast.screen.dart';
import 'package:recparenting/src/room/ui/screens/chat.screen.dart';
import 'package:recparenting/src/home/ui/home.screen.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';
import 'package:recparenting/src/therapist/ui/screens/therapist_bio.screen.dart';

class RouterRec {
  static Map<String, Widget Function(BuildContext)> routes = {
    homeRoute: (_) => const HomePage(),
    splashRoute: (_) => const SplashScreen(),
    loginRoute: (_) => const LoginScreen(),
    passwordRecoveryRoute: (_) => const PasswordRecoveryScreen(),
    conferenceRoute: (_) => const ConferenceScreen(),
    patientsRoute: (_) => const PatientsScreen(),
    patientShowRoute: (context) {
      final Patient patient =
          ModalRoute.of(context)!.settings.arguments as Patient;
      return PatientShowScreen(patient: patient);
    },
    webPageRoute: (context) {
      final WebpageArguments argument =
          ModalRoute.of(context)!.settings.arguments as WebpageArguments;
      return WebPageScreen(arguments: argument);
    },
    chatRoute: (context) {
      final Patient patient =
          ModalRoute.of(context)!.settings.arguments as Patient;
      return ChatScreen(patient: patient);
    },
    joinConferenceRoute: (context) {
      final String argument =
          ModalRoute.of(context)!.settings.arguments as String;
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => MethodChannelCoordinator()),
          ChangeNotifierProvider(create: (_) => JoinMeetingProvider()),
          ChangeNotifierProvider(create: (context) => MeetingProvider(context)),
        ],
        child: JoinMeetingScreen(
          conferenceId: argument,
        ),
      );
    },
    contactPageRoute: (_) => const ContactScreen(),
    therapistBioPageRoute: (context) {
      final Therapist argument =
          ModalRoute.of(context)!.settings.arguments as Therapist;
      return TherapistBioScreen(therapist: argument);
    },
    calendarRoute: (_) => const CalendarScreen(),
    premiumRoute: (_) => const PremiumScreen(),
    forumsRoute: (_) => const ForumsScreen(),
    notificationsRoute: (_) => const NotificationsScreen(),
    podcastsRoute: (_) => const PodcastScreen(),
    masterclassRoute: (_) => const MasterclassScreen(),

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

  static goToThread(BuildContext context, ThreadForum threadForum) =>
      Navigator.push(context, MaterialPageRoute<ForumBloc>(builder: (_) {
        return BlocProvider.value(
          value: BlocProvider.of<ForumBloc>(context),
          child: ThreadScreen(
            thread: threadForum,
          ),
        );
      }));

  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
        builder: (context) => const Scaffold(
                body: Center(
              child: Text('Página no encontrada'),
            )));
  }
}
