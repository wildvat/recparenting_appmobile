import 'package:flutter/material.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
import 'package:recparenting/src/current_user/helpers/current_user_builder.dart';
import 'package:recparenting/src/current_user/providers/current_user.provider.dart';
import 'package:recparenting/src/patient/models/change_therapist.model.dart';
import 'package:recparenting/src/patient/providers/patient.provider.dart';
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
  Patient? _currentUser;
  ChangeTherapistReasons? _changeTherapistReasons;
  final PatientApi _patientApi = PatientApi();
  bool _loadingSendChange = false;
  bool? _changeTherapistSended = false;

  @override
  void initState() {
    super.initState();
    _currentUser = CurrentUserBuilder().patient();
  }

  List<Widget> getWidgetsChangeTherapistReasons(StateSetter currentState) {
    List<Widget> widgets = [];
    widgets.add(Padding(
        padding: const EdgeInsets.all(20),
        child: TextDefault(
          AppLocalizations.of(context)!.patientChangeTherapistTitle,
          fontWeight: FontWeight.bold,
        )));

    for (var value in ChangeTherapistReasons.values) {
      widgets.add(RadioListTile(
        title: TextDefault(AppLocalizations.of(context)!
            .patientChangeTherapistReason(value.name)),
        value: value,
        groupValue: _changeTherapistReasons,
        onChanged: (ChangeTherapistReasons? value) {
          if (value != null) {
            currentState(() {
              _changeTherapistReasons = value;
            });
          }
        },
      ));
    }
    widgets.add(_loadingSendChange
        ? const CircularProgressIndicator()
        : ElevatedButton(
            onPressed: _changeTherapistReasons == null
                ? null
                : () async {
                    currentState(() => _loadingSendChange = true);
                    await _patientApi.requestChangeTherapist(
                        widget._therapist.id, _changeTherapistReasons!);
                    CurrentUserApi().reloadUser();
                    currentState(() => _loadingSendChange = false);
                    if (mounted) {
                      Navigator.pop(context, true);
                    }
                  },
            child: _changeTherapistReasons != null
                ? TextDefault(AppLocalizations.of(context)!.generalSend)
                : TextDefault(AppLocalizations.of(context)!
                    .patientChangeTherapistTitle)));
    return widgets;
  }

  Widget _getAction(StateSetter currentState) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: getWidgetsChangeTherapistReasons(currentState),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_currentUser!.isMyCurrentTherapist(widget._therapist)) {
      return const SizedBox();
    }
    return FutureBuilder<ChangeTherapist?>(
        future: _patientApi.hasRequestChangeTherapist(widget._therapist.id),
        builder: (BuildContext context,
            AsyncSnapshot<ChangeTherapist?> snapshotAvailable) {
          if (snapshotAvailable.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshotAvailable.connectionState == ConnectionState.done) {
            if (snapshotAvailable.error != null) {
              return const SizedBox();
              // return SizedBox(child: Text(snapshotAvailable.error.toString(), style: TextStyle(color: Colors.red)));
            }
            if (!snapshotAvailable.hasData) {
              return ElevatedButton.icon(
                onPressed: _changeTherapistSended != null &&
                        _changeTherapistSended!
                    ? null
                    : () async {
                        _changeTherapistSended =
                            await showModalBottomSheet<bool?>(
                                isScrollControlled: true,
                                backgroundColor: Colors.white,
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(builder:
                                      (BuildContext context,
                                          StateSetter myState) {
                                    return DraggableScrollableSheet(
                                        expand: false,
                                        initialChildSize: 0.7,
                                        minChildSize: 0.2,
                                        maxChildSize: 0.75,
                                        builder: (BuildContext context,
                                            ScrollController scrollController) {
                                          return SingleChildScrollView(
                                            controller: scrollController,
                                            child: _getAction(myState),
                                          );
                                        });
                                  });
                                });
                        if (_changeTherapistSended != null &&
                            _changeTherapistSended!) {
                          setState(() {});
                        }
                      },
                icon: const Icon(Icons.sync_problem),
                label: TextDefault(
                    AppLocalizations.of(context)!.terapistChangeButton),
              );
            }
          }
          return const SizedBox();
        });
  }
}
