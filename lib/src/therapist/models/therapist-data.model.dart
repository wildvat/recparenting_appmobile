import 'package:recparenting/_shared/models/gender.enum.dart';
import 'package:recparenting/_shared/models/language.enum.dart';
import 'package:recparenting/_shared/models/religion.enum.dart';
import 'package:recparenting/src/therapist/models/therapist_areas_expertise.enum.dart';
import 'package:recparenting/src/therapist/models/working-hours.model.dart';

class TherapistData {
  late String bio;
  late int years_practice;
  late List<AreasExpertise> areas_expertise;
  late WorkingHours? working_hours;
  late Religion religion;
  late Gender gender;
  late List<Language> language;

  TherapistData(this.bio, this.years_practice, this.areas_expertise,
      this.working_hours, this.religion, this.gender, this.language);

  TherapistData.fromJson(Map<String, dynamic> json) {
    List apiLanguages = json['language'] as List;
    List apiAreasExpertise = json['areas_expertise'] as List;

    bio = json['bio'];
    years_practice = json['years_practice'];
    religion = convertStringToReligion(json['religion']);
    gender = convertStringToGender(json['gender']);
    language =
        apiLanguages.map((i) => convertStringToLanguage(i.toString())).toList();
    areas_expertise = apiAreasExpertise.map((i) {
      return convertStringFromAreaExpertise(i.toString());
    }).toList();
    working_hours = json['working_hours'] != null
        ? WorkingHours.fromJson(json['working_hours'])
        : null;
  }
/*
  toJson(){
    return {
        'bio': bio,
        'years_practice': years_practice,
        'areas_expertise': areas_expertise,
        'working_hours': working_hours.toJson(),
        'language': language,
        'gender' :gender

    };
  }*/
}
