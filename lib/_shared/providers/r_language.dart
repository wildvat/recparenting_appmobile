import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recparenting/navigator_key.dart';

class R {
  R._();

  static AppLocalizations get string =>
      AppLocalizations.of(navigatorKey.currentContext!)!;
}
