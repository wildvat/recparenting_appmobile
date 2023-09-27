enum Religion {
  catholic,
  christian,
  jewish,
  muslim,
  nonReligious,
  other
}

String convertReligionToString(Religion religion) {
  late String value;
  switch (religion) {
    case Religion.catholic:
      value = 'catholic';
      break;
    case Religion.christian:
      value = 'christian';
      break;
    case Religion.jewish:
      value = 'jewish';
      break;
    case Religion.muslim:
      value = 'muslim';
      break;
    case Religion.nonReligious:
      value = 'non-religious';
      break;
    default:
      value = 'non-religious';
      break;
  }
  return value;
}

Religion convertStringToReligion(String religion) {
  late Religion value;
  switch (religion) {
    case 'catholic':
      value = Religion.catholic;
      break;
    case 'christian':
      value = Religion.christian;
      break;
    case 'jewish':
      value = Religion.jewish;
      break;
    case 'muslim':
      value = Religion.muslim;
      break;
    case 'non-religious':
      value = Religion.nonReligious;
      break;
    default:
      value = Religion.nonReligious;
      break;
  }
  return value;
}
