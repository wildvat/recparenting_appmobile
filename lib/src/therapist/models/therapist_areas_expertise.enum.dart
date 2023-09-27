enum AreasExpertise {
  pregnancy,
  adoption,
  difficultiesConceiving,
  issuesDuringInfancy,
  issuesDuringToddlerhood,
  issuesDuringChildhood,
  issuesDuringAdolescence,
  educationIssues,
  learningDifficulties,
  technologyUse,
  discipline,
  anxiety,
  depressionAndMoodDisorders,
  eatingDisorders,
  bullyingCyberbullyingAndSexting,
  atypicalDevelopment,
  substanceUse,
  siblingRilvalry,
  parentChildConflict,
  childrensMentalHealth,
  adultMentalHealth,
  coParentingIssues,
  parentingAlone,
  divorce,
  relationships,
  bereavement,
  trauma,
}

String convertAreaExpertiseToString(AreasExpertise area) {
  late String value;
  switch (area) {
    case AreasExpertise.adoption:
      value = 'adoption';
      break;
    case AreasExpertise.anxiety:
      value = 'anxiety';
      break;
    case AreasExpertise.atypicalDevelopment:
      value = 'atypical_development';
      break;
    case AreasExpertise.bereavement:
      value = 'bereavement';
      break;
    case AreasExpertise.bullyingCyberbullyingAndSexting:
      value = 'bullying_cyberbullying_and_sexting';
      break;
    case AreasExpertise.childrensMentalHealth:
      value = 'childrens_mental_health';
      break;
    case AreasExpertise.coParentingIssues:
      value = 'co-parenting_issues';
      break;
    case AreasExpertise.depressionAndMoodDisorders:
      value = 'depression_and_mood_disorders';
      break;
    case AreasExpertise.difficultiesConceiving:
      value = 'difficulties_conceiving';
      break;
    case AreasExpertise.discipline:
      value = 'discipline';
      break;
    case AreasExpertise.divorce:
      value = 'divorce';
      break;
    case AreasExpertise.eatingDisorders:
      value = 'eating_disorders';
      break;
    case AreasExpertise.educationIssues:
      value = 'education_issues';
      break;
    case AreasExpertise.issuesDuringAdolescence:
      value = 'issues_during_adolescence';
      break;
    case AreasExpertise.issuesDuringChildhood:
      value = 'issues_during_childhood';
      break;
    case AreasExpertise.issuesDuringInfancy:
      value = 'issues_during_infancy';
      break;
    case AreasExpertise.issuesDuringToddlerhood:
      value = 'issues_during_toddlerhood';
      break;
    case AreasExpertise.learningDifficulties:
      value = 'learning_difficulties';
      break;
    case AreasExpertise.parentChildConflict:
      value = 'parent-child_conflict';
      break;
    case AreasExpertise.parentingAlone:
      value = 'parenting_alone';
      break;
    case AreasExpertise.pregnancy:
      value = 'pregnancy';
      break;
    case AreasExpertise.relationships:
      value = 'relationships';
      break;
    case AreasExpertise.siblingRilvalry:
      value = 'sibling_rilvalry';
      break;
    case AreasExpertise.substanceUse:
      value = 'substance_use';
      break;
    case AreasExpertise.technologyUse:
      value = 'technology_use';
      break;
    case AreasExpertise.trauma:
      value = 'trauma';
      break;
    case AreasExpertise.adultMentalHealth:
      value = 'adult_mental_health';
      break;

    default:
      value = 'adoption';
      break;
  }
  return value;
}

AreasExpertise convertStringFromAreaExpertise(String reason) {
  late AreasExpertise value;
  switch (reason) {
    case 'adoption':
      value = AreasExpertise.adoption;
      break;
    case 'anxiety':
      value = AreasExpertise.anxiety;
      break;
    case 'atypical_development':
      value = AreasExpertise.atypicalDevelopment;
      break;
    case 'bereavement':
      value = AreasExpertise.bereavement;
      break;
    case 'bullying_cyberbullying_and_sexting':
      value = AreasExpertise.bullyingCyberbullyingAndSexting;
      break;
    case 'childrens_mental_health':
      value = AreasExpertise.childrensMentalHealth;
      break;
    case 'co-parenting_issues':
      value = AreasExpertise.coParentingIssues;
      break;
    case 'depression_and_mood_disorders':
      value = AreasExpertise.depressionAndMoodDisorders;
      break;
    case 'difficulties_conceiving':
      value = AreasExpertise.difficultiesConceiving;
      break;
    case 'discipline':
      value = AreasExpertise.discipline;
      break;
    case 'divorce':
      value = AreasExpertise.divorce;
      break;
    case 'eating_disorders':
      value = AreasExpertise.eatingDisorders;
      break;
    case 'education_issues':
      value = AreasExpertise.educationIssues;
      break;
    case 'issues_during_adolescence':
      value = AreasExpertise.issuesDuringAdolescence;
      break;
    case 'issues_during_childhood':
      value = AreasExpertise.issuesDuringChildhood;
      break;
    case 'issues_during_infancy':
      value = AreasExpertise.issuesDuringInfancy;
      break;
    case 'issues_during_toddlerhood':
      value = AreasExpertise.issuesDuringToddlerhood;
      break;
    case 'learning_difficulties':
      value = AreasExpertise.learningDifficulties;
      break;
    case 'parent-child_conflict':
      value = AreasExpertise.parentChildConflict;
      break;
    case 'parenting_alone':
      value = AreasExpertise.parentingAlone;
      break;
    case 'pregnancy':
      value = AreasExpertise.pregnancy;
      break;
    case 'relationships':
      value = AreasExpertise.relationships;
      break;
    case 'sibling_rilvalry':
      value = AreasExpertise.siblingRilvalry;
      break;
    case 'substance_use':
      value = AreasExpertise.substanceUse;
      break;
    case 'technology_use':
      value = AreasExpertise.technologyUse;
      break;
    case 'trauma':
      value = AreasExpertise.trauma;
      break;
    case 'adult_mental_health':
      value = AreasExpertise.adultMentalHealth;
      break;

    default:
      value = AreasExpertise.adoption;
      break;
  }
  return value;
}
