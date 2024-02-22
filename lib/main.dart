import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:bugsnag_flutter/bugsnag_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/_shared/bloc/language/language_bloc.dart';
import 'package:recparenting/_shared/helpers/action_notification_push.dart';
import 'package:recparenting/_shared/ui/widgets/bloc_builder3.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:recparenting/environments/env.dart';
import 'package:recparenting/environments/env_model.dart';
import 'package:recparenting/navigator_key.dart';
import 'package:recparenting/routes.dart';
import 'package:recparenting/src/current_user/bloc/current_user_bloc.dart';
import 'package:recparenting/src/notifications/bloc/notification_bloc.dart';
import 'package:recparenting/theme.dart';

import '_shared/helpers/push_permision.dart';
import '_shared/providers/route_observer.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (env.type == EnvTypes.production) {
    await bugsnag.start(apiKey: env.bugsnagApiKey);
  }
  runApp(const MyApp());
  /*
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((__) => runApp(const MyApp()));
  */
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

    if (initialMessage != null) {
      _handleOnMessageOpenedApp(initialMessage);
    }
    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleOnMessageOpenedApp);
    FirebaseMessaging.onMessage.listen(_handleOnMessage);
  }

  void _handleOnMessage(RemoteMessage message) {
    //print('onMessage | app open ${message.data}');
    ActionNotificationPush(message: message).execute(_notificationsBloc);
  }

  void _handleOnMessageOpenedApp(RemoteMessage message) {
    //print('onMessageOpenedApp | app semiOpened ${message.data}');
    ActionNotificationPush(message: message)
        .redirectFromPush(_notificationsBloc);
  }

  @override
  void initState() {
    super.initState();
    getPermissionPushApp();
    setupInteractedMessage();
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
              navigatorObservers: [routeObserverRec],
              locale: Locale(state.language),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            );
          }
          return const CircularProgressIndicator();
        }));
  }
}
