enum Gender {
  male,
  female,
  transGender,
  nonBinary,
  preferNotToAnswer,
  other,
}

String convertGenderToString(Gender gender) {
  late String value;
  switch (gender) {
    case Gender.male:
      value = 'male';
      break;
    case Gender.female:
      value = 'female';
      break;
    case Gender.transGender:
      value = 'trans-gender';
      break;
    case Gender.nonBinary:
      value = 'non-binary';
      break;
    case Gender.preferNotToAnswer:
      value = 'prefer-not-to-answer';
      break;
    default:
      value = 'other';
      break;
  }
  return value;
}

Gender convertStringToGender(String gender) {
  late Gender value;
  switch (gender) {
    case 'male':
      value = Gender.male;
      break;
    case 'female':
      value = Gender.female;
      break;
    case 'trans-gender':
      value = Gender.transGender;
      break;
    case 'non-binary':
      value = Gender.nonBinary;
    case 'prefer-not-to-answer':
      value = Gender.preferNotToAnswer;
      break;
    default:
      value = Gender.other;
      break;
  }
  return value;
}
