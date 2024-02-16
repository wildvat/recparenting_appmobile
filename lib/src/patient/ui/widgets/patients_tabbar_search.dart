import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recparenting/_shared/ui/widgets/search_input.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/src/patient/bloc/patients_bloc.dart';

class PatientsTabbarSearchWidget extends StatefulWidget
    implements PreferredSizeWidget {
  const PatientsTabbarSearchWidget({super.key});

  @override
  State<PatientsTabbarSearchWidget> createState() =>
      _PatientsTabbarSearchWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _PatientsTabbarSearchWidgetState extends State<PatientsTabbarSearchWidget>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicatorColor: colorRecDark,
      dividerColor: Colors.transparent,
      indicator: const BoxDecoration(),
      padding: const EdgeInsets.only(bottom: 10),
      controller: TabController(length: 1, vsync: this),
      tabs: [
        Tab(
          child: SearchInputForm(
              onFieldSubmitted: (value) => context
                  .read<PatientsBloc>()
                  .add(PatientsFetch(page: 1, search: '$value'))),
        )
      ],
    );
  }
}
