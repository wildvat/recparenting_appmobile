import 'package:recparenting/src/therapist/models/therapist.model.dart';
import 'package:recparenting/src/therapist/models/therapists.model.dart';

class TherapistActive{
    late final Therapist active;
    late final Therapists previous;

    TherapistActive(this.active, this.previous);

    TherapistActive.fromJson(Map<String, dynamic> json){
      active = Therapist.fromJson(json['active']);
      previous = Therapists.fromJson(json['previous']);
    }
}