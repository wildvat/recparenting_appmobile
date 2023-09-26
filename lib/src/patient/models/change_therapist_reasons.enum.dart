enum ChangeTherapistReasons {
  scheduleDoesNotMatch,
  wasNotResponsive,
  wasNotAddressingMyNeeds,
  wasNotConnect,
  wantDifferentExpertise,
  therapistRecommendedChange,
  other
}

String convertChangeTherapistReasonToString(ChangeTherapistReasons reason) {
  late String value;
  switch (reason) {
    case ChangeTherapistReasons.scheduleDoesNotMatch:
      value = 'schedule_does_not_match';
      break;
    case ChangeTherapistReasons.wasNotResponsive:
      value = 'was_not_responsive';
      break;
    case ChangeTherapistReasons.wasNotAddressingMyNeeds:
      value = 'was_not_addressing_my_needs';
      break;
    case ChangeTherapistReasons.wasNotConnect:
      value = 'was_not_connect';
      break;
    case ChangeTherapistReasons.wantDifferentExpertise:
      value = 'want_different_expertise';
      break;
    case ChangeTherapistReasons.therapistRecommendedChange:
      value = 'therapist_recommended_change';
      break;
    default:
      value = 'other';
      break;
  }
  return value;
}

ChangeTherapistReasons convertStringFromChangeTherapistReason(String reason) {
  late ChangeTherapistReasons value;
  switch (reason) {
    case 'schedule_does_not_match':
      value = ChangeTherapistReasons.scheduleDoesNotMatch;
      break;
    case 'was_not_responsive':
      value = ChangeTherapistReasons.wasNotResponsive;
      break;
    case 'was_not_addressing_my_needs':
      value = ChangeTherapistReasons.wasNotAddressingMyNeeds;
      break;
    case 'was_not_connect':
      value = ChangeTherapistReasons.wasNotConnect;
      break;
    case 'want_different_expertise':
      value = ChangeTherapistReasons.wantDifferentExpertise;
      break;
    case 'therapist_recommended_change':
      value = ChangeTherapistReasons.therapistRecommendedChange;
      break;

    default:
      value = ChangeTherapistReasons.other;
      break;
  }
  return value;
}
