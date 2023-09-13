import 'package:recparenting/src/therapist/models/working-hours.model.dart';

class TherapistData{
  late String bio;
  late int years_practice;
  late List<String> areas_expertise;
  late WorkingHours working_hours;
  late String religion;
  late String gender;
  late List<String> language;

  TherapistData(this.bio, this.years_practice, this.areas_expertise,
      this.working_hours, this.religion, this.gender, this.language);

  TherapistData.fromJson(Map<String, dynamic> json) {
    List apiLanguages = json['language'] as List;
    List apiAreasExpertise = json['areas_expertise'] as List;

    bio = json['bio'];
    years_practice = json['years_practice'];
    religion = json['religion'];
    gender = json['gender'] ;
    language = apiLanguages.map((i) => i.toString()).toList();
    areas_expertise = apiAreasExpertise.map((i) => i.toString()).toList();
    working_hours = WorkingHours.fromJson(json['working_hours']);
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