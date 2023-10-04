import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/models/webpage_arguments.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:recparenting/src/current_user/bloc/current_user_bloc.dart';
import 'package:recparenting/src/home/home_card.widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
        backgroundColor: colorRecDark,
        title: AppLocalizations.of(context)!.menuHome,
        body: BlocBuilder<CurrentUserBloc, CurrentUserState>(
            builder: (context, state) {
          if (state is CurrentUserLoaded) {
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
                          constraints.maxWidth / (constraints.maxHeight - 60),
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
                        onPress: () =>
                            Navigator.pushNamed(context, masterclassRoute),
                        colorBack: TextColors.masterclass.color,
                        colorText: TextColors.masterclassDark,
                        isExternalLink: true,
                        pathImage: 'dashboard_masterclass-min',
                        text: AppLocalizations.of(context)!.menuMasterclasses,
                      ),
                      HomeCardWidget(
                        onPress: () =>
                            Navigator.pushNamed(context, podcastsRoute),
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
          }
          return const Text('No login user, no deberia estar aqui');
        }));
  }
}
