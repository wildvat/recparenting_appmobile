import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'dart:developer' as developer;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/_shared/bloc/language/language_bloc.dart';
import 'package:recparenting/_shared/helpers/action_notification_push.dart';
import 'package:recparenting/_shared/ui/widgets/bloc_builder3.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:recparenting/navigator_key.dart';
import 'package:recparenting/routes.dart';
import 'package:recparenting/src/current_user/bloc/current_user_bloc.dart';
import 'package:recparenting/src/notifications/bloc/notification_bloc.dart';
import 'package:recparenting/theme.dart';

import '_shared/helpers/push_permision.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((__) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NotificationBloc _notificationsBloc = NotificationBloc();
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    developer.log('push redirect message ${message.data['type']}');
  }

  @override
  void initState() {
    super.initState();

    getPermissionPushApp();
    setupInteractedMessage();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      developer.log('onMessage | app opened ${message.notification!.title}');
      developer.log('push redirect message ${message.data}');
      ActionNotificationPush(message: message, context: context)
          .execute(_notificationsBloc);
      developer.log('he lanzado el pusg');
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      developer.log('onMessageOpenedApp | app semiOpened ${message.data}');
      developer.log('push redirect message ${message.data}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<LanguageBloc>(
            create: (context) => LanguageBloc(),
          ),
          BlocProvider<CurrentUserBloc>(
            create: (BuildContext context) => CurrentUserBloc(),
          ),
          BlocProvider<NotificationBloc>(
            create: (BuildContext context) =>
                _notificationsBloc..add(const NotificationsFetch(page: 1)),
          )
        ],
        child: BlocBuilder2<LanguageBloc, LanguageState, CurrentUserBloc,
                CurrentUserState>(
            builder: (BuildContext context, LanguageState state,
                CurrentUserState stateCurrentUser) {
          if (state is LanguageLoaded) {
            return MaterialApp(
              title: 'REC Parenting',
              theme: RecThemeData.lightTheme,
              //theme: RecThemeData.darkTheme,
              routes: RouterRec.routes,
              onGenerateRoute: RouterRec.generateRoute,
              initialRoute: splashRoute,
              scaffoldMessengerKey: scaffoldKey,
              //home: const HomePage(),
              navigatorKey: navigatorKey,
              locale: Locale(state.language),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            );
          }
          return const CircularProgressIndicator();
        }));
  }
}
