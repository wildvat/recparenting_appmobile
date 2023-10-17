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

            return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: LayoutBuilder(builder: (context, constraints) {
                  final double width = (constraints.maxWidth / 2) - 30;
                  final double widthColumn3 = (constraints.maxWidth / 3) - 30;
                  final double height =
                      (constraints.maxHeight / 2) - 30 - 90 - 20;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/images/rec-logo-inverse.svg',
                          height: 60,
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          children: [
                            HomeCardWidget(
                              width: width,
                              height: height,
                              onPress: () {
                                if (state.user.isPatient()) {
                                  Navigator.pushNamed(context, chatRoute,
                                      arguments: state.user);
                                } else {
                                  Navigator.pushNamed(context, patientsRoute);
                                }
                              },
                              colorBack: TextColors.chat.color,
                              colorText: TextColors.chatDark,
                              pathImage: 'dashboard_one-min',
                              text: state.user.isPatient()
                                  ? AppLocalizations.of(context)!.menuChat
                                  : AppLocalizations.of(context)!.menuPatients,
                            ),
                            HomeCardWidget(
                              width: width,
                              height: height,
                              onPress: () async {
                                String url = '${env.web}masterclasses/';
                                if (_language == 'es') {
                                  url = '${env.web}es/masterclasses/';
                                }
                                url = '${env.url}login-token?redirect_to=$url';
                                Navigator.pushNamed(context, webPageRoute,
                                    arguments: WebpageArguments(
                                        title: AppLocalizations.of(context)!
                                            .menuMasterclasses,
                                        url: url,
                                        token: _accessToken));
                              },
                              colorBack: TextColors.masterclass.color,
                              colorText: TextColors.masterclassDark,
                              isExternalLink: true,
                              pathImage: 'dashboard_masterclass-min',
                              text: 'Calendar',
                            ),
                            HomeCardWidget(
                              width: widthColumn3,
                              height: height,
                              onPress: () async {
                                String url = '${env.web}masterclasses/';
                                if (_language == 'es') {
                                  url = '${env.web}es/masterclasses/';
                                }
                                url = '${env.url}login-token?redirect_to=$url';
                                Navigator.pushNamed(context, webPageRoute,
                                    arguments: WebpageArguments(
                                        title: AppLocalizations.of(context)!
                                            .menuMasterclasses,
                                        url: url,
                                        token: _accessToken));
                              },
                              colorBack: TextColors.masterclass.color,
                              colorText: TextColors.masterclassDark,
                              isExternalLink: true,
                              pathImage: 'dashboard_masterclass-min',
                              text: 'Calendar',
                            ),
                            HomeCardWidget(
                              width: widthColumn3,
                              height: height,
                              onPress: () async {
                                String url = '${env.web}masterclasses/';
                                if (_language == 'es') {
                                  url = '${env.web}es/masterclasses/';
                                }
                                url = '${env.url}login-token?redirect_to=$url';
                                Navigator.pushNamed(context, webPageRoute,
                                    arguments: WebpageArguments(
                                        title: AppLocalizations.of(context)!
                                            .menuMasterclasses,
                                        url: url,
                                        token: _accessToken));
                              },
                              colorBack: TextColors.masterclass.color,
                              colorText: TextColors.masterclassDark,
                              isExternalLink: true,
                              pathImage: 'dashboard_masterclass-min',
                              text: 'Calendar',
                            ),
                            HomeCardWidget(
                              width: widthColumn3,
                              height: height,
                              onPress: () async {
                                String url = '${env.web}masterclasses/';
                                if (_language == 'es') {
                                  url = '${env.web}es/masterclasses/';
                                }
                                url = '${env.url}login-token?redirect_to=$url';
                                Navigator.pushNamed(context, webPageRoute,
                                    arguments: WebpageArguments(
                                        title: AppLocalizations.of(context)!
                                            .menuMasterclasses,
                                        url: url,
                                        token: _accessToken));
                              },
                              colorBack: TextColors.masterclass.color,
                              colorText: TextColors.masterclassDark,
                              isExternalLink: true,
                              pathImage: 'dashboard_masterclass-min',
                              text: AppLocalizations.of(context)!
                                  .menuMasterclasses,
                            ),
                            /*
                            state.user.isPatient()
                                ? HomeCardWidget(
                                    width: width,
                                    height: height,
                                    onPress: () async {
                                      String url = '${env.web}podcast/';
                                      if (_language == 'es') {
                                        url = '${env.web}es/podcast/';
                                      }
                                      url =
                                          '${env.url}login-token?redirect_to=$url';
                                      Navigator.pushNamed(context, webPageRoute,
                                          arguments: WebpageArguments(
                                              title:
                                                  AppLocalizations.of(context)!
                                                      .menuMasterclasses,
                                              url: url,
                                              token: _accessToken));
                                    },
                                    colorBack: TextColors.recLight.color,
                                    colorText: TextColors.rec,
                                    isExternalLink: true,
                                    pathImage: 'dashboard_podcast-min',
                                    text: AppLocalizations.of(context)!
                                        .menuPodcast,
                                  )
                                : const SizedBox.shrink(),
                            state.user.isPatient()
                                ? HomeCardWidget(
                                    width: width,
                                    height: height,
                                    onPress: () => Navigator.pushNamed(
                                        context, webPageRoute,
                                        arguments: WebpageArguments(
                                            title: AppLocalizations.of(context)!
                                                .menuFaqs,
                                            url:
                                                'https://www.recparenting.com/faq-users/')),
                                    colorBack: TextColors.rec.color,
                                    colorText: TextColors.recLight,
                                    isExternalLink: true,
                                    pathImage: 'dashboard_faqs-min',
                                    text:
                                        AppLocalizations.of(context)!.menuFaqs,
                                  )
                                : const SizedBox.shrink()
                                */
                          ],
                        ),
                        /*
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 30),
                            child: Column(
                              children: [
                                ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          TextColors.masterclass.color,
                                      minimumSize: const Size.fromHeight(50),
                                    ),
                                    child: TextDefault(
                                      AppLocalizations.of(context)!
                                          .menuMasterclasses,
                                      color: TextColors.masterclassDark,
                                    )),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          TextColors.recLight.color,
                                      minimumSize: const Size.fromHeight(50),
                                    ),
                                    child: TextDefault(
                                      AppLocalizations.of(context)!.menuPodcast,
                                      color: TextColors.rec,
                                    )),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: TextColors.rec.color,
                                      minimumSize: const Size.fromHeight(50),
                                    ),
                                    child: TextDefault(
                                      AppLocalizations.of(context)!.menuFaqs,
                                      color: TextColors.recLight,
                                    )),
                              ],
                            ))
                            */
                      ],
                    ),
                    /*
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      HomeCardWidget(
                        onPress: () {
                          if (state.user.isPatient()) {
                            Navigator.pushNamed(context, chatRoute,
                                arguments: state.user);
                          } else {
                            Navigator.pushNamed(context, patientsRoute);
                          }
                        },
                        colorBack: TextColors.chat.color,
                        colorText: TextColors.chatDark,
                        pathImage: 'dashboard_one-min',
                        text: state.user.isPatient()
                            ? AppLocalizations.of(context)!.menuChat
                            : AppLocalizations.of(context)!.menuPatients,
                      ),
                    ],
                  )
                ],
              ),
              */
                  );
                }));
            /*
            return LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  SvgPicture.asset(
                    'assets/images/rec-logo-inverse.svg',
                    height: 60,
                  ),
                  GridView(
                    padding: const EdgeInsets.all(20),
                    shrinkWrap: true,
                    //padding: EdgeInsets.all(30),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio:
                          constraints.maxWidth / (constraints.maxHeight - 100),
                    ),
                    children: [
                      HomeCardWidget(
                        onPress: () {
                          if (state.user.isPatient()) {
                            Navigator.pushNamed(context, chatRoute,
                                arguments: state.user);
                          } else {
                            Navigator.pushNamed(context, patientsRoute);
                          }
                        },
                        colorBack: TextColors.chat.color,
                        colorText: TextColors.chatDark,
                        pathImage: 'dashboard_one-min',
                        text: state.user.isPatient()
                            ? AppLocalizations.of(context)!.menuChat
                            : AppLocalizations.of(context)!.menuPatients,
                      ),
                      HomeCardWidget(
                        onPress: () async {
                          String url = '${env.web}masterclasses/';
                          if (_language == 'es') {
                            url = '${env.web}es/masterclasses/';
                          }
                          url = '${env.url}login-token?redirect_to=$url';
                          Navigator.pushNamed(context, webPageRoute,
                              arguments: WebpageArguments(
                                  title: AppLocalizations.of(context)!
                                      .menuMasterclasses,
                                  url: url,
                                  token: _accessToken));
                        },
                        colorBack: TextColors.masterclass.color,
                        colorText: TextColors.masterclassDark,
                        isExternalLink: true,
                        pathImage: 'dashboard_masterclass-min',
                        text: AppLocalizations.of(context)!.menuMasterclasses,
                      ),
                      HomeCardWidget(
                        onPress: () async {
                          String url = '${env.web}podcast/';
                          if (_language == 'es') {
                            url = '${env.web}es/podcast/';
                          }
                          url = '${env.url}login-token?redirect_to=$url';
                          Navigator.pushNamed(context, webPageRoute,
                              arguments: WebpageArguments(
                                  title: AppLocalizations.of(context)!
                                      .menuMasterclasses,
                                  url: url,
                                  token: _accessToken));
                        },
                        colorBack: TextColors.recLight.color,
                        colorText: TextColors.rec,
                        isExternalLink: true,
                        pathImage: 'dashboard_podcast-min',
                        text: AppLocalizations.of(context)!.menuPodcast,
                      ),
                      HomeCardWidget(
                        onPress: () => Navigator.pushNamed(
                            context, webPageRoute,
                            arguments: WebpageArguments(
                                title: AppLocalizations.of(context)!.menuFaqs,
                                url:
                                    'https://www.recparenting.com/faq-users/')),
                        colorBack: TextColors.rec.color,
                        colorText: TextColors.recLight,
                        isExternalLink: true,
                        pathImage: 'dashboard_faqs-min',
                        text: AppLocalizations.of(context)!.menuFaqs,
                      )
                    ],
                  )
                ],
              );
            });
            */
          }
          return TitleDefault(AppLocalizations.of(context)!.userNotLogged);
        }));
  }
}
