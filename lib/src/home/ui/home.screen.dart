import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recparenting/_shared/bloc/language/language_bloc.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/models/webpage_arguments.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:recparenting/_shared/ui/widgets/title.widget.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:recparenting/src/current_user/bloc/current_user_bloc.dart';
import 'package:recparenting/src/home/ui/home_card.widget.dart';
import 'package:recparenting/src/home/ui/home_patient.screen.dart';
import 'package:recparenting/src/home/ui/home_therapist.screen%20.dart';

import '../../../environments/env.dart';
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
        backgroundColor: colorRecDark,
        title: AppLocalizations.of(context)!.menuHome,
        body: BlocBuilder<CurrentUserBloc, CurrentUserState>(
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
        }));
  }
}
