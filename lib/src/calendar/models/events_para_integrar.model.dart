
import 'event.model.dart';
//TODO integrar cuando acabe cris con calendario
/*
unificar EventsModel y despues en el EventsModel actual usar este modelo y al otro llamarce eventModelCalendar o similar
 */
class EventsModelNew {
  late final int total;
  late final List<EventModel> events;

  EventsModelNew({required this.total, required this.events});

  EventsModelNew.fromJson(Map<String, dynamic> json) {

    total = json['total'];
    List eventsApi = json['items'];
    if (eventsApi.isNotEmpty) {
      events = eventsApi.map((item) {
        return EventModel.fromJson(item);
      }).toList();
    }else{
      events = [];
    }
  }
}
