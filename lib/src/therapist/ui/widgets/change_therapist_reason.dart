import 'package:flutter/material.dart';
import 'package:recparenting/_shared/ui/widgets/text.widget.dart';
import 'package:recparenting/src/current_user/helpers/current_user_builder.dart';
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
  late Future<ChangeTherapist?> _hasRequestChangeTherapist;

  @override
  void initState() {
    super.initState();

    _currentUser = CurrentUserBuilder().patient();
    _hasRequestChangeTherapist =
        _patientApi.hasRequestChangeTherapist(widget._therapist.id);
  }

  List<Widget> getWidgetsChangeTherapistReasons() {

    List<Widget> widgets = [];
    widgets.add(Padding(
        padding: const EdgeInsets.all(20),
        child:TextDefault(
      AppLocalizations.of(context)!.patientChangeTherapistTitle,
      fontWeight: FontWeight.bold,
    )));

    for (var value in ChangeTherapistReasons.values) {

      widgets.add(ListTile(
        title: TextDefault(AppLocalizations.of(context)!.patientChangeTherapistReason(
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
        child: _changeTherapistReasons != null ? TextDefault(
            AppLocalizations.of(context)!.generalSend) : TextDefault(
            AppLocalizations.of(context)!.patientChangeTherapistTitle),
        onPressed: () {
          _patientApi.requestChangeTherapist(
              widget._therapist.id, _changeTherapistReasons!).then((value) => Navigator.pop(context ));
          //CurrentUserApi().reloadUser().then((value) {});
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
                        return DraggableScrollableSheet(
                            expand: false,
                            initialChildSize: 0.7,
                            minChildSize: 0.2,
                            maxChildSize: 0.75,
                        builder: (BuildContext context, ScrollController scrollController) {
                          return SingleChildScrollView(
                            controller: scrollController,
                            child: _getAction(),
                          );
                        });

                      });
                },
                icon: const Icon(Icons.sync_problem),
                label: TextDefault(AppLocalizations.of(context)!.terapistChangeButton),
              );
            }
          }
          return const SizedBox();
        });
  }

}