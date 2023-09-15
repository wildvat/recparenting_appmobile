class WorkingHours {
  WorkingHoursStartEndList? monday;
  WorkingHoursStartEndList? tuesday;
  WorkingHoursStartEndList? wednesday;
  WorkingHoursStartEndList? thursday;
  WorkingHoursStartEndList? friday;
  WorkingHoursStartEndList? saturday;
  WorkingHoursStartEndList? sunday;

  WorkingHours(
      {this.monday,
      this.tuesday,
      this.wednesday,
      this.thursday,
      this.friday,
      this.saturday,
      this.sunday});

  WorkingHours.fromJson(Map<String, dynamic> json) {
    if (json['monday'] != null) {
      monday = WorkingHoursStartEndList.fromJson(json['monday']);
    }
    if (json['tuesday'] != null) {
      tuesday = WorkingHoursStartEndList.fromJson(json['tuesday']);
    }
    if (json['wednesday'] != null) {
      wednesday = WorkingHoursStartEndList.fromJson(json['wednesday']);
    }
    if (json['thursday'] != null) {
      thursday = WorkingHoursStartEndList.fromJson(json['thursday']);
    }
    if (json['friday'] != null) {
      friday = WorkingHoursStartEndList.fromJson(json['friday']);
    }
    if (json['saturday'] != null) {
      saturday = WorkingHoursStartEndList.fromJson(json['saturday']);
    }
    if (json['sunday'] != null) {
      sunday = WorkingHoursStartEndList.fromJson(json['sunday']);
    }
  }

  List<Map<String, dynamic>> toList() {
    List<Map<String, dynamic>> wHours = [];
    if (monday != null) {
      wHours.add({'day': 'monday', 'startEnd': monday});
    }
    if (tuesday != null) {
      wHours.add({'day': 'tuesday', 'startEnd': tuesday});
    }
    if (wednesday != null) {
      wHours.add({'day': 'wednesday', 'startEnd': wednesday});
    }
    if (thursday != null) {
      wHours.add({'day': 'thursday', 'startEnd': thursday});
    }
    if (friday != null) {
      wHours.add({'day': 'friday', 'startEnd': friday});
    }
    if (saturday != null) {
      wHours.add({'day': 'saturday', 'startEnd': saturday});
    }
    if (sunday != null) {
      wHours.add({'day': 'sunday', 'startEnd': sunday});
    }
    return wHours;
  }
}

class WorkingHoursStartEndList {
  List<WorkingHoursStartEnd>? hours;

  WorkingHoursStartEndList(this.hours);

  WorkingHoursStartEndList.fromJson(List<dynamic> json) {
    hours = json.map((item) {
      return WorkingHoursStartEnd.fromJson(item);
    }).toList();
  }
}

class WorkingHoursStartEnd {
  late String start;
  late String end;

  WorkingHoursStartEnd(this.start, this.end);

  WorkingHoursStartEnd.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
  }
}
