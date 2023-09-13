import 'package:recparenting/src/room/models/room.model.dart';

class Rooms {
  late final int total;
  late final List<Room?> rooms;

  Rooms({required this.total, required this.rooms});

  Rooms.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    List roomsApi = json['items'];
    if (roomsApi.isNotEmpty) {
      rooms = roomsApi.map((item) {
        return Room.fromJson(item);
      }).toList();
    }
  }
}
