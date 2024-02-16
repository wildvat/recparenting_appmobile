enum Language {
  es,
  en,
  fr,
  ar,
}

String convertLanguageToString(Language language) {
  late String value;
  switch (language) {
    case Language.es:
      value = 'es';
      break;
    case Language.en:
      value = 'en';
      break;
      case Language.fr:
      value = 'fr';
      break;
      case Language.ar:
      value = 'ar';
      break;
    default:
      value = 'en';
      break;
  }
  return value;
}

Language convertStringToLanguage(String language) {
  late Language value;
  switch (language) {
    case 'es':
      value = Language.es;
      break;
   case 'fr':
      value = Language.fr;
      break;
    case 'ar':
      value = Language.ar;
      break;
    default:
      value = Language.en;
      break;
  }
  return value;
}
