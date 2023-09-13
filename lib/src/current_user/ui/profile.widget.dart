import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:recparenting/_shared/models/user.model.dart';
import 'package:recparenting/_shared/ui/select_language.widget.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/src/auth/providers/login.provider.dart';
import 'package:recparenting/src/current_user/bloc/current_user_bloc.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late User _currentUser;
  late CurrentUserBloc _currentUserBloc;
  late Widget _avatar;

  @override
  void initState() {
    super.initState();
    _currentUserBloc = context.read<CurrentUserBloc>();
    _currentUser = (_currentUserBloc.state as CurrentUserLoaded).user;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: colorRecDark,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 70,
            width: 70,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              // todo api always return same image && image is an svg
              child: _currentUser.avatar.contains('/avatar/user')
                  ? SvgPicture.network(
                      _currentUser.avatar,
                    )
                  : Image.network(_currentUser.avatar),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '${_currentUser.name!} ${_currentUser.lastname}',
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            _currentUser.email!,
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            _currentUser.nickname!,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  AuthApi().logout();
                },
                icon: const Icon(Icons.logout),
                label: Text(AppLocalizations.of(context)!.logout),
              ),
              SelectLanguageWidget()
            ],
          )
        ],
      ),
    );
  }
}
