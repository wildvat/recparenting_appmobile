import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/_shared/bloc/language/language_bloc.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:recparenting/navigator_key.dart';
import 'package:recparenting/routes.dart';
import 'package:recparenting/src/home/ui/home.screen.dart';
import 'package:recparenting/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _languageBloc = LanguageBloc();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<LanguageBloc>(
            create: (context) => _languageBloc,
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
