import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/_shared/models/webpage_arguments.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:recparenting/src/home/ui/home_card.widget.dart';
import '../../../environments/env.dart';

class HomePatientWidget extends StatelessWidget {
  final User user;
  final String lang;
  final String accessToken;
  const HomePatientWidget(
      {required this.user,
      required this.lang,
      required this.accessToken,
      super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          SvgPicture.asset(
            'assets/images/rec-logo-inverse.svg',
            height: 50,
          ),
          GridView(
            padding: const EdgeInsets.all(10),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (constraints.maxWidth - 40) /
                    (constraints.maxHeight - 100)),
            children: [
              HomeCardWidget(
                onPress: () => Navigator.pushNamed(context, patientShowRoute,
                    arguments: user),
                colorBack: TextColors.chat.color,
                colorText: TextColors.chatDark,
                pathImage: 'dashboard_one-min',
                text: AppLocalizations.of(context)!.menuRoom,
              ),
              HomeCardWidget(
                onPress: () => Navigator.pushNamed(context, forumsRoute),
                colorBack: TextColors.rec.color,
                colorText: TextColors.recLight,
                pathImage: 'dashboard_faqs-min',
                text: AppLocalizations.of(context)!.menuCommunity,
              ),
              HomeCardWidget(
                onPress: () async {
                  String url = '${env.web}masterclasses/';
                  if (lang == 'es') {
                    url = '${env.web}es/masterclasses/';
                  }
                  url = '${env.url}login-token?redirect_to=$url';
                  Navigator.pushNamed(context, webPageRoute,
                      arguments: WebpageArguments(
                          title:
                              AppLocalizations.of(context)!.menuMasterclasses,
                          url: url,
                          token: accessToken));
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
                  if (lang == 'es') {
                    url = '${env.web}es/podcast/';
                  }
                  url = '${env.url}login-token?redirect_to=$url';
                  Navigator.pushNamed(context, webPageRoute,
                      arguments: WebpageArguments(
                          title: AppLocalizations.of(context)!.menuPodcast,
                          url: url,
                          token: accessToken));
                },
                colorBack: TextColors.recLight.color,
                colorText: TextColors.rec,
                isExternalLink: true,
                pathImage: 'dashboard_podcast-min',
                text: AppLocalizations.of(context)!.menuPodcast,
              )
            ],
          )
        ],
      );
    });
  }
}
