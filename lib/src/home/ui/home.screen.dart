import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/_shared/bloc/language/language_bloc.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:recparenting/_shared/ui/widgets/title.widget.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/src/current_user/bloc/current_user_bloc.dart';
import 'package:recparenting/src/home/ui/home_patient.screen.dart';
import 'package:recparenting/src/home/ui/home_therapist.screen%20.dart';
import '../../auth/repository/token_respository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final LanguageBloc _languageBloc;
  String _language = 'en';
  String _accessToken = '';

  @override
  void initState() {
    super.initState();
    _languageBloc = context.read<LanguageBloc>();
    if (_languageBloc.state is LanguageLoaded) {
      _language = _languageBloc.state.language;
    }
    TokenRepository().getToken().then((value) {
      _accessToken = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
        //backgroundColor: colorRecDark,
        title: AppLocalizations.of(context)!.menuHome,
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              .48,
              .48,
              .495,
              .495,
            ],
            colors: [
              colorRecDark,
              colorRecLight,
              colorRecLight,
              Colors.white,
            ],
          )),
          child: BlocBuilder<CurrentUserBloc, CurrentUserState>(
              builder: (context, state) {
            if (state is CurrentUserLoaded) {
              return Center(
                  child: state.user.isPatient()
                      ? HomePatientWidget(
                          user: state.user,
                          lang: _language,
                          accessToken: _accessToken)
                      : HomeTherapistWidget(
                          lang: _language, accessToken: _accessToken));
            }
            return TitleDefault(AppLocalizations.of(context)!.userNotLogged);
          }),
        ));
  }
}
