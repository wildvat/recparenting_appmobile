import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/_shared/ui/widgets/scaffold_default.dart';
import 'package:recparenting/src/current_user/bloc/current_user_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
        title: AppLocalizations.of(context)!.menuHome,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Logueado',
              ),
              SizedBox(
                  height: 200,
                  child: BlocBuilder<CurrentUserBloc, CurrentUserState>(
                      builder: (context, state) {
                    if (state is CurrentUserLoaded) {
                      return Column(
                        children: [
                          Text("NOMBRE: ${state.user.name}"),
                          Text("EMAIL: ${state.user.email ?? "Sin email"}"),
                          Text("ID: ${state.user.id.toString()}"),
                        ],
                      );
                    }
                    return const Text('No login user, no deberia estar aqui');
                  })),
            ],
          ),
        ));
  }
}
