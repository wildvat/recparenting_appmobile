import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recparenting/src/patient/models/change_therapist.model.dart';
import 'package:recparenting/src/patient/providers/patient.provider.dart';

import '../../../current_user/bloc/current_user_bloc.dart';
import '../../../current_user/providers/current_user.provider.dart';
import '../../../patient/models/change_therapist_reasons.enum.dart';
import '../../../patient/models/patient.model.dart';
import '../../models/therapist.model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangeTherapistReasonWidget extends StatefulWidget {
  const ChangeTherapistReasonWidget({
    super.key,
    required Therapist therapist,
  }) : _therapist = therapist;

  final Therapist _therapist;

  @override
  State<ChangeTherapistReasonWidget> createState() =>
      _ChangeTherapistReasonWidgetState();
}

class _ChangeTherapistReasonWidgetState
    extends State<ChangeTherapistReasonWidget> {
  late CurrentUserBloc _currentUserBloc;
  late CurrentUserLoaded _currentUserLoaded;
  Patient? _currentUser;
  ChangeTherapistReasons? _changeTherapistReasons;
  final PatientApi _patientApi = PatientApi();
  late Future<ChangeTherapist?> _hasRequestChangeTherapist;

  @override
  void initState() {
    super.initState();
    _currentUserBloc = context.read<CurrentUserBloc>();
    if (_currentUserBloc.state is CurrentUserLoaded) {
      _currentUserLoaded = _currentUserBloc.state as CurrentUserLoaded;
      if (_currentUserLoaded.user is Patient) {
        _currentUser = _currentUserLoaded.user as Patient;
      } else {
        throw Exception('puede un terapeuta ver esto?');
      }
    } else {
      throw Exception('No existe usuario logueado');
    }
    _hasRequestChangeTherapist =
        _patientApi.hasRequestChangeTherapist(widget._therapist.id);
  }

  List<Widget> getWidgetsChangeTherapistReasons() {
    List<Widget> widgets = [];
    widgets.add(Text(
      AppLocalizations.of(context)!.patientChangeTherapistTitle,
      style: const TextStyle(fontSize: 18),
    ));

    for (var value in ChangeTherapistReasons.values) {
      widgets.add(ListTile(
        title: Text(AppLocalizations.of(context)!.patientChangeTherapistReason(
            value.name)),
        leading: Radio<ChangeTherapistReasons>(
          value: value,
          onChanged: (ChangeTherapistReasons? value) {
            if (value != null) {
              setState(() {
                _changeTherapistReasons = value;
              });
            }
          },
          groupValue: _changeTherapistReasons,
        ),
      ),);
    }
    widgets.add(ElevatedButton(
        child: _changeTherapistReasons != null ? Text(
            AppLocalizations.of(context)!.generalSend) : Text(
            AppLocalizations.of(context)!.patientChangeTherapistTitle),
        onPressed: () {
          _patientApi.requestChangeTherapist(
              widget._therapist.id, _changeTherapistReasons!);
          CurrentUserApi().reloadUser().then((value) {});
          Navigator.pop(context);
        }
    ));
    return widgets;
  }

  Widget _getAction() {
    return Container(
      padding: const EdgeInsets.all(20),
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: getWidgetsChangeTherapistReasons(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_currentUser!.isMyCurrentTherapist(widget._therapist)) {
      return const SizedBox();
    }
    return FutureBuilder<ChangeTherapist?>(
        future: _hasRequestChangeTherapist,
        builder: (BuildContext context,
            AsyncSnapshot<ChangeTherapist?> snapshotAvailable) {
          if (snapshotAvailable.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshotAvailable.connectionState == ConnectionState.done) {
            if(snapshotAvailable.error != null){
              return const SizedBox();
             // return SizedBox(child: Text(snapshotAvailable.error.toString(), style: TextStyle(color: Colors.red)));
            }
            if (!snapshotAvailable.hasData) {
              return ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet<void>(
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      context: context,
                      builder: (BuildContext context) {
                        return _getAction();
                      });
                },
                icon: const Icon(Icons.sync_problem),
                label: Text(AppLocalizations.of(context)!.terapistChangeButton),
              );
            }
          }
          return const SizedBox();
        });
  }

}