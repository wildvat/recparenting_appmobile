import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/_shared/bloc/language/language_bloc.dart';
import 'package:recparenting/_shared/models/webpage_arguments.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:recparenting/environments/env.dart';
import 'package:recparenting/src/auth/repository/token_respository.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';

class BottomAppBarTherapist extends StatefulWidget {
  final Therapist therapist;
  const BottomAppBarTherapist({
    required this.therapist,
    super.key,
  });

  @override
  State<BottomAppBarTherapist> createState() => _BottomAppBarTherapistState();
}

class _BottomAppBarTherapistState extends State<BottomAppBarTherapist> {
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
    return BottomAppBar(
      height: 60,
      padding: const EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 0),
      color: colorRecDark,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.person_search_outlined,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () => Navigator.pushNamed(context, patientsRoute)),
          IconButton(
            icon: const Icon(
              Icons.calendar_month_outlined,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, calendarRoute),
          ),
          const SizedBox(width: 50),
          IconButton(
              icon: const Icon(
                Icons.post_add_outlined,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, forumsRoute)),
          IconButton(
              icon: const Icon(
                Icons.quiz_outlined,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () => Navigator.pushNamed(context, webPageRoute,
                  arguments: WebpageArguments(
                      title: AppLocalizations.of(context)!.menuFaqs,
                      url: '${env.web}faq-users/')))
        ],
      ),
    );
  }
}
