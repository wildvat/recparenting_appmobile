import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recparenting/_shared/ui/widgets/show_api_error.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/src/patient/providers/patient.provider.dart';

import '../../../current_user/bloc/current_user_bloc.dart';
import '../../../patient/models/patient.model.dart';
import '../../models/therapist.model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SharedChatWithTherapistWidget extends StatefulWidget {
  const SharedChatWithTherapistWidget({
    super.key,
    required Therapist therapist,
  }) : _therapist = therapist;

  final Therapist _therapist;

  @override
  State<SharedChatWithTherapistWidget> createState() =>
      _SharedChatWithTherapistWidgetState();
}

class _SharedChatWithTherapistWidgetState
    extends State<SharedChatWithTherapistWidget> {
  late CurrentUserLoaded _currentUserLoaded;
  Patient? _currentUser;
  final PatientApi _patientApi = PatientApi();
  bool _sharedValue = false;

  final MaterialStateProperty<Icon?> thumbIcon =
  MaterialStateProperty.resolveWith<Icon?>(
        (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  @override
  void initState() {
    super.initState();
    _currentUserLoaded = context
        .read<CurrentUserBloc>()
        .state as CurrentUserLoaded;
    if (_currentUserLoaded.user is Patient) {
      _currentUser = _currentUserLoaded.user as Patient;
    } else {
      throw Exception('puede un terapeuta ver esto?');
    }
    getValueShared();
  }

  getValueShared() {
    _patientApi.isSharedRoomWith(widget._therapist.id).then((value) {
      setState(() {
        _sharedValue = value.data;
      });

    });
  }

  _onSubmit(valueShared){
    _patientApi.sharedRoomWith(widget._therapist.id, valueShared).then((
        value) {
      if (value.error != null) {
        ShowApiErrorWidget(context: context, apiResponse: value)
            .execute();
        setState(() {
          _sharedValue = valueShared?false:true;
        });
      } else {
        setState(() {
          _sharedValue = value.data;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(!_currentUser!.isMyCurrentTherapist(widget._therapist)) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(AppLocalizations.of(context)!.patientSharedRoomWithTherapist),
          Switch(
            thumbIcon: thumbIcon,
            activeColor: colorRec,
            activeTrackColor: colorRecLight,
            inactiveThumbColor: Colors.blueGrey.shade600,
            inactiveTrackColor: Colors.grey.shade400,
            splashRadius: 50.0,
            value: _sharedValue,
            onChanged: (value) {
              print('value $value');
              setState(() {
                _sharedValue = value;
              });
              _onSubmit(value);
            },
          )
        ],
      );
    }else{
      return const SizedBox();
    }
  }

}