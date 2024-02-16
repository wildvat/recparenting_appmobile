import 'package:intl/intl.dart';
import 'package:recparenting/navigator_key.dart';
import 'package:recparenting/src/room/models/message.model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String timeToStringFromMessage(Message message) {
  DateTime now = DateTime.now();
  if(now.difference(message.createdAt)
      .inDays
      .abs() == 0){
    return AppLocalizations.of(navigatorKey.currentContext!)!.today;
  }
  if(now.difference(message.createdAt)
      .inDays
      .abs() < 6){
    return DateFormat.EEEE().format(message.createdAt);
  }
  return  DateFormat.yMMMMd().format(message.createdAt);
}