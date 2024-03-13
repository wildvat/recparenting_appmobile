import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/models/webpage_arguments.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:recparenting/environments/env.dart';
import 'package:recparenting/src/home/ui/home_card.widget.dart';

class HomeTherapistWidget extends StatelessWidget {
  final String lang;
  final String accessToken;
  const HomeTherapistWidget(
      {required this.lang, required this.accessToken, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/rec-logo-inverse.svg',
                    height: 50,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      HomeCardWidget(
                        pathImage: 'dashboard_one-min',
                        onPress: () =>
                            Navigator.pushNamed(context, patientsRoute),
                        isExternalLink: false,
                        colorBack: TextColors.chat.color,
                        colorText: TextColors.chatDark,
                        text: AppLocalizations.of(context)!.menuPatients,
                      ),
                      HomeCardWidget(
                        pathImage: 'dashboard_calendar-min',
                        onPress: () =>
                            Navigator.pushNamed(context, calendarRoute),
                        isExternalLink: false,
                        colorBack: TextColors.light.color,
                        colorText: TextColors.rec,
                        text: AppLocalizations.of(context)!.menuCalendar,
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HomeCardWidget(
                        onPress: () {
                          String url = '${env.web}masterclasses/';
                          if (lang == 'es') {
                            url = '${env.web}es/masterclasses/';
                          }
                          url = '${env.url}login-token?redirect_to=$url';
                          Navigator.pushNamed(context, webPageRoute,
                              arguments: WebpageArguments(
                                  title: AppLocalizations.of(context)!
                                      .menuMasterclasses,
                                  url: url,
                                  token: accessToken));
                        },
                        isExternalLink: true,
                        colorBack: TextColors.masterclass.color,
                        colorText: TextColors.masterclassDark,
                        text: AppLocalizations.of(context)!.menuMasterclasses,
                      ),
                      HomeCardWidget(
                        onPress: () {
                          String url = '${env.web}podcast/';
                          if (lang == 'es') {
                            url = '${env.web}es/podcast/';
                          }
                          url = '${env.url}login-token?redirect_to=$url';
                          Navigator.pushNamed(context, webPageRoute,
                              arguments: WebpageArguments(
                                  title:
                                      AppLocalizations.of(context)!.menuPodcast,
                                  url: url,
                                  token: accessToken));
                        },
                        isExternalLink: true,
                        colorBack: TextColors.recLight.color,
                        colorText: TextColors.rec,
                        text: AppLocalizations.of(context)!.menuPodcast,
                      ),
                      HomeCardWidget(
                          onPress: () {
                            String url = '${env.web}faq-users/';
                            if (lang == 'es') {
                              url = '${env.web}es/faq-users/';
                            }
                            url = '${env.url}login-token?redirect_to=$url';
                            Navigator.pushNamed(context, webPageRoute,
                                arguments: WebpageArguments(
                                    title:
                                        AppLocalizations.of(context)!.menuFaqs,
                                    url: url));
                          },
                          isExternalLink: true,
                          colorBack: TextColors.rec.color,
                          colorText: TextColors.recLight,
                          text: AppLocalizations.of(context)!.menuFaqs),
                    ],
                  ),
                  const SizedBox(height: 10),
                ])));
  }
}
