import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recparenting/constants/colors.dart';
import 'package:recparenting/src/current_user/bloc/current_user_bloc.dart';
import 'package:recparenting/src/patient/models/patient.model.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';

import '../../../../_shared/helpers/avatar_image.dart';
import 'change_therapist_reason.dart';

class TherapistBioHeaderWidget extends StatefulWidget {
  const TherapistBioHeaderWidget({
    super.key,
    required Therapist therapist,
  }) : _therapist = therapist;

  final Therapist _therapist;

  @override
  State<TherapistBioHeaderWidget> createState() => _TherapistBioHeaderWidgetState();
}

class _TherapistBioHeaderWidgetState extends State<TherapistBioHeaderWidget> {

  late CurrentUserLoaded _currentUserLoaded;


  @override
  void initState() {
    super.initState();
    _currentUserLoaded = context.read<CurrentUserBloc>().state as CurrentUserLoaded;
    if(_currentUserLoaded.user is !Patient){
      throw Exception('puede un terapeuta ver esto?');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20),
      color: colorRecDark,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(500)),
              child: AvatarImage(user: widget._therapist),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            widget._therapist.getFullName(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 15),
          ChangeTherapistReasonWidget(therapist: widget._therapist),
        ],
      ),
    );
  }
}
