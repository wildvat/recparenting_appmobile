import 'event.model.dart';
class EventsModel {
  late final int total;
  late final List<EventModel> events;

  EventsModel({required this.total, required this.events});

  EventsModel.fromJson(Map<String, dynamic> json) {

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
