import 'package:calendar_view/calendar_view.dart';

class CreateEventApiResponse {
  final String? error;
  final CalendarEventData? event;
  const CreateEventApiResponse({this.error, this.event});
}
