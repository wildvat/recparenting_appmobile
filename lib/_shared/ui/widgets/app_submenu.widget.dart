import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recparenting/_shared/bloc/language/language_bloc.dart';
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/_shared/models/webpage_arguments.dart';
import 'package:recparenting/_shared/ui/widgets/app_submenu_item.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/constants/router_names.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/src/current_user/bloc/current_user_bloc.dart';
import 'package:recparenting/src/current_user/ui/profile.widget.dart';

import '../../../environments/env.dart';
import '../../../src/auth/repository/token_respository.dart';

class AppSubmenuWidget extends StatefulWidget {
  const AppSubmenuWidget({
    super.key,
  });

  @override
  State<AppSubmenuWidget> createState() => _AppSubmenuWidgetState();
}

class _AppSubmenuWidgetState extends State<AppSubmenuWidget> {
  final MenuController _menuController = MenuController();

  late final LanguageBloc _languageBloc;
  late final User _currentUser;
  String? _accessToken;

  @override
  void initState() {
    super.initState();
    _languageBloc = context.read<LanguageBloc>();
    _currentUser =
        (context.read<CurrentUserBloc>().state as CurrentUserLoaded).user;
    accessToken();
  }

  accessToken() async {
    TokenRepository().getToken().then((value) {
      _accessToken = value;
    });
  }

  String getLang() {
    if (_languageBloc.state is LanguageLoaded) {
      return _languageBloc.state.language;
    }
    return 'en';
  }

  @override
  Widget build(BuildContext context) {
    return SubmenuButton(
      controller: _menuController,
      alignmentOffset: const Offset(0, 8),
      menuStyle: const MenuStyle(
          backgroundColor: MaterialStatePropertyAll(colorRecDark)),
      menuChildren: [
        AppSubmenuItemWidget(
            onPress: () async {
              if (mounted) {
                await showModalBottomSheet(
                    useRootNavigator: true,
                    context: context,
                    builder: (context) {
                      return const ProfileWidget();
                    });
                await Future.delayed(const Duration(milliseconds: 10));
                _menuController.close();
              }
            },
            titleUrl: AppLocalizations.of(context)!.menuProfile),
        _currentUser.isPatient()
            ? AppSubmenuItemWidget(
                onPress: () async {
                  await Navigator.pushNamed(context, forumsRoute);
                  await Future.delayed(const Duration(milliseconds: 10));
                  _menuController.close();
                },
                titleUrl: AppLocalizations.of(context)!.menuCommunity)
            : const SizedBox.shrink(),
        AppSubmenuItemWidget(
            onPress: () async {
              await Navigator.pushNamed(context, contactPageRoute);
              await Future.delayed(const Duration(milliseconds: 10));
              _menuController.close();
            },
            titleUrl: AppLocalizations.of(context)!.menuContact),
        AppSubmenuItemWidget(
            isExternalLink: true,
            onPress: () async {
              String url = '${env.web}privacy-policy/';
              if (getLang() == 'es') {
                url = '${env.web}es/privacy-policy/';
              }
              url = '${env.url}login-token?redirect_to=$url';

              await Navigator.pushNamed(context, webPageRoute,
                  arguments: WebpageArguments(
                      title: AppLocalizations.of(context)!.menuLegal,
                      url: url,
                      token: _accessToken ?? ''));
              await Future.delayed(const Duration(milliseconds: 10));
              _menuController.close();
            },
            titleUrl: AppLocalizations.of(context)!.menuLegal),
        AppSubmenuItemWidget(
            isExternalLink: true,
            onPress: () async {
              String url = '${env.web}blog/';
              if (getLang() == 'es') {
                url = '${env.web}es/blog/';
              }
              url = '${env.url}login-token?redirect_to=$url';

              await Navigator.pushNamed(context, webPageRoute,
                  arguments: WebpageArguments(
                      title: AppLocalizations.of(context)!.menuBlog,
                      url: url,
                      token: _accessToken ?? ''));
              await Future.delayed(const Duration(milliseconds: 10));
              _menuController.close();
            },
            titleUrl: AppLocalizations.of(context)!.menuBlog),
        AppSubmenuItemWidget(
            isExternalLink: true,
            onPress: () async {
              String url = '${env.web}masterclasses/';
              if (getLang() == 'es') {
                url = '${env.web}es/masterclasses/';
              }
              url = '${env.url}login-token?redirect_to=$url';
              await Navigator.pushNamed(context, webPageRoute,
                  arguments: WebpageArguments(
                      title: AppLocalizations.of(context)!.menuMasterclasses,
                      url: url,
                      token: _accessToken ?? ''));
              await Future.delayed(const Duration(milliseconds: 10));
              _menuController.close();
            },
            titleUrl: AppLocalizations.of(context)!.menuMasterclasses),
        AppSubmenuItemWidget(
            isExternalLink: true,
            onPress: () async {
              String url = '${env.web}podcast/';
              if (getLang() == 'es') {
                url = '${env.web}es/podcast/';
              }
              url = '${env.url}login-token?redirect_to=$url';
              await Navigator.pushNamed(context, webPageRoute,
                  arguments: WebpageArguments(
                      title: AppLocalizations.of(context)!.menuPodcast,
                      url: url,
                      token: _accessToken ?? ''));
              await Future.delayed(const Duration(milliseconds: 10));
              _menuController.close();
            },
            titleUrl: AppLocalizations.of(context)!.menuPodcast),
        AppSubmenuItemWidget(
            onPress: () async {
              await Navigator.pushNamed(context, deleteAccountRoute);
              await Future.delayed(const Duration(milliseconds: 10));
              _menuController.close();
            },
            titleUrl: AppLocalizations.of(context)!.menuDeleteAccount),
      ],
      child: const Icon(Icons.more_vert, color: Colors.white),
    );
  }
}
