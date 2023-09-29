import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/_shared/models/text_colors.enum.dart';
import 'package:recparenting/_shared/models/text_sizes.enum.dart';
import 'package:recparenting/_shared/models/webpage_arguments.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
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
              return GridView(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio:
                      constraints.maxWidth / constraints.maxHeight,
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
                    pathImage: 'dashboard_one-min',
                    text: state.user.isPatient()
                        ? 'Chat'
                        : 'Listado de pacientes',
                  ),
                  HomeCardWidget(
                    onPress: () =>
                        Navigator.pushNamed(context, masterclassRoute),
                    pathImage: 'dashboard_masterclass-min',
                    text: 'Masterclasses',
                  ),
                  HomeCardWidget(
                    onPress: () => Navigator.pushNamed(context, podcastsRoute),
                    pathImage: 'dashboard_podcast-min',
                    text: 'Podcast',
                  ),
                  HomeCardWidget(
                    onPress: () => Navigator.pushNamed(context, webPageRoute,
                        arguments: WebpageArguments(
                            title: 'FAQs',
                            url: 'https://www.recparenting.com/faq-users/')),
                    pathImage: 'dashboard_faqs-min',
                    text: 'FAQs',
                  )
                ],
              );
            });
          }
          return const Text('No login user, no deberia estar aqui');
        }));
  }
}
