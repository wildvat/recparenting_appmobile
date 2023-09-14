class WorkingHours {
  WorkingHoursStartEnd? monday;
  WorkingHoursStartEnd? tuesday;
  WorkingHoursStartEnd? wednesday;
  WorkingHoursStartEnd? thursday;
  WorkingHoursStartEnd? friday;
  WorkingHoursStartEnd? saturday;
  WorkingHoursStartEnd? sunday;

  WorkingHours(this.monday, this.tuesday, this.wednesday, this.thursday,
      this.friday, this.saturday, this.sunday);

  WorkingHours.fromJson(Map<String, dynamic> json) {
    if (json['monday'] != null) {
      monday = WorkingHoursStartEnd.fromList(json['monday']);
    }
    if (json['tuesday'] != null) {
      tuesday = WorkingHoursStartEnd.fromList(json['tuesday']);
    }
    if (json['wednesday'] != null) {
      wednesday = WorkingHoursStartEnd.fromList(json['wednesday']);
    }
    if (json['thursday'] != null) {
      thursday = WorkingHoursStartEnd.fromList(json['thursday']);
    }
    if (json['friday'] != null) {
      friday = WorkingHoursStartEnd.fromList(json['friday']);
    }
    if (json['saturday'] != null) {
      saturday = WorkingHoursStartEnd.fromList(json['saturday']);
    }
    if (json['sunday'] != null) {
      sunday = WorkingHoursStartEnd.fromList(json['sunday']);
    }
  }

  List<dynamic> toList() {
    List<Map<String, dynamic>> wHours = [];
    if (monday != null) {
      wHours.add({'day': 'monday', 'startEnd': monday!.toJson()});
    }
    if (tuesday != null) {
      wHours.add({'day': 'tuesday', 'startEnd': tuesday!.toJson()});
    }
    if (wednesday != null) {
      wHours.add({'day': 'wednesday', 'startEnd': wednesday!.toJson()});
    }
    if (thursday != null) {
      wHours.add({'day': 'thursday', 'startEnd': thursday!.toJson()});
    }
    if (friday != null) {
      wHours.add({'day': 'friday', 'startEnd': friday!.toJson()});
    }
    if (saturday != null) {
      wHours.add({'day': 'saturday', 'startEnd': saturday!.toJson()});
    }
    if (sunday != null) {
      wHours.add({'day': 'sunday', 'startEnd': sunday!.toJson()});
    }
    return wHours;
    /*
    [
      {'day': 'monday', 'startEnd': monday!.toJson()}
    ];
    */
    /*
    return {
      'monday': monday != null ? monday!.toJson() : null,
      'tuesday': tuesday != null ? tuesday!.toJson() : null,
      'wednesday': wednesday != null ? wednesday!.toJson() : null,
      'thursday': thursday != null ? thursday!.toJson() : null,
      'friday': friday != null ? friday!.toJson() : null,
      'saturday': saturday != null ? saturday!.toJson() : null,
      'sunday': sunday != null ? sunday!.toJson() : null,
    };
    */
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

  WorkingHoursStartEnd.fromList(List<dynamic> json) {
    end = json[0]['end'];
    start = json[0]['start'];
  }

  toJson() {
    return {
      'start': start,
      'end': end,
    };
  }
}
