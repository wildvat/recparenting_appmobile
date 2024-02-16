import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recparenting/src/therapist/models/therapist.model.dart';

import '../../../_shared/models/user.model.dart';
import '../../../navigator_key.dart';
import '../../patient/models/patient.model.dart';
import '../bloc/current_user_bloc.dart';

class CurrentUserBuilder {
  final CurrentUserBloc _currentUserBloc =
      BlocProvider.of<CurrentUserBloc>(navigatorKey.currentContext!);

  CurrentUserBuilder();

  User value() {
    if (_currentUserBloc.state is CurrentUserLoaded) {
      User user = (_currentUserBloc.state as CurrentUserLoaded).user;
      if (user.isPatient()) {
        return patient();
      }
      if (user.isTherapist()) {
        return therapist();
      }
      return user;
    } else {
      throw Exception('No existe usuario logueado');
    }
  }

  Patient patient() {
    if (_currentUserBloc.state is CurrentUserLoaded) {
      return (_currentUserBloc.state as CurrentUserLoaded).user as Patient;
    } else {
      throw Exception('No existe usuario logueado o no es paciente');
    }
  }

  Therapist therapist() {
    if (_currentUserBloc.state is CurrentUserLoaded) {
      return (_currentUserBloc.state as CurrentUserLoaded).user as Therapist;
    } else {
      throw Exception('No existe usuario logueado o no es terapeuta');
    }
  }
}
