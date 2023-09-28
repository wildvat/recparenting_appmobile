import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/_shared/bloc/language/language_bloc.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:recparenting/navigator_key.dart';
import 'package:recparenting/routes.dart';
import 'package:recparenting/src/current_user/bloc/current_user_bloc.dart';
import 'package:recparenting/src/notifications/bloc/notification_bloc.dart';
import 'package:recparenting/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((__) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _languageBloc = LanguageBloc();
  final _currentUserBloc = CurrentUserBloc();
  final _notificationsBloc = NotificationBloc();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<LanguageBloc>(
            create: (context) => _languageBloc,
          ),
          BlocProvider<CurrentUserBloc>(
            create: (BuildContext context) => _currentUserBloc,
          ),
          BlocProvider<NotificationBloc>(
            create: (BuildContext context) =>
                _notificationsBloc..add(const NotificationsFetch(page: 1)),
          )
        ],
        child: BlocBuilder<LanguageBloc, LanguageState>(
            builder: (BuildContext context, LanguageState state) {
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
