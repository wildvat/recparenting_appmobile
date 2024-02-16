import 'dart:developer' as dev;

class WorkingHours {
  late WorkingHoursStartEndList monday;
  late WorkingHoursStartEndList tuesday;
  late WorkingHoursStartEndList wednesday;
  late WorkingHoursStartEndList thursday;
  late WorkingHoursStartEndList friday;
  late WorkingHoursStartEndList saturday;
  late WorkingHoursStartEndList sunday;

  WorkingHours(
      {required this.monday,
      required this.tuesday,
      required this.wednesday,
      required this.thursday,
      required this.friday,
      required this.saturday,
      required this.sunday});

  _workingHoursToLocal(
      {required dynamic json,
      required int timeOffset,
      required WorkingHoursStartEndList current,
      required WorkingHoursStartEndList prev,
      required WorkingHoursStartEndList next}) {
    final WorkingHoursStartEndList mondayTmp =
        WorkingHoursStartEndList.fromJson(json);
    mondayTmp.hours.map((hour) {
      final startHourLocal =
          int.parse(hour!.start.substring(0, 2)) + timeOffset;
      final startMinutes = hour.start.substring(3, 5);
      final endHourLocal = int.parse(hour.end.substring(0, 2)) + timeOffset;
      final endMinutes = hour.end.substring(3, 5);
      String sameDayHourStart =
          startHourLocal < 10 ? '0$startHourLocal' : '$startHourLocal';
      String sameDayHourEnd =
          endHourLocal < 10 ? '0$endHourLocal' : '$endHourLocal';

      if (startHourLocal < 0 && endHourLocal < 0) {
        dev.log('all hour to prev day');
        sameDayHourStart = '';
        sameDayHourEnd = '';
        final String startLocalFormat = startHourLocal + 24 < 10
            ? '0${startHourLocal + 24}'
            : '${startHourLocal + 24}';
        final String endLocalFormat = endHourLocal + 24 < 10
            ? '0${endHourLocal + 24}'
            : '${endHourLocal + 24}';
        final WorkingHoursStartEnd workingHourLocal = WorkingHoursStartEnd(
            '$startLocalFormat:$startMinutes', '$endLocalFormat:$endMinutes');
        prev.hours.add(workingHourLocal);
      } else if (startHourLocal >= 24 && endHourLocal > 24) {
        dev.log('all hour to next day');
        sameDayHourStart = '';
        sameDayHourEnd = '';
        final String startLocalFormat = startHourLocal - 24 < 10
            ? '0${startHourLocal - 24}'
            : '${startHourLocal - 24}';
        final String endLocalFormat = endHourLocal - 24 < 10
            ? '0${endHourLocal - 24}'
            : '${endHourLocal - 24}';
        final WorkingHoursStartEnd workingHourLocal = WorkingHoursStartEnd(
            '$startLocalFormat:$startMinutes', '$endLocalFormat:$endMinutes');

        next.hours.add(workingHourLocal);
      } else if (startHourLocal < 0 && endHourLocal >= 0) {
        dev.log('part of hour to prev day');
        final WorkingHoursStartEnd workingHourLocal = WorkingHoursStartEnd(
            '${startHourLocal + 24}:$startMinutes', '24:$endMinutes');
        sameDayHourStart = '00';
        sameDayHourEnd = endHourLocal < 10 ? '0$endHourLocal' : '$endHourLocal';
        prev.hours.add(workingHourLocal);
      } else if (startHourLocal < 24 && endHourLocal > 24) {
        dev.log('part of hour to next day');
        sameDayHourEnd = '24:$endMinutes';
        final String endLocalFormat = endHourLocal - 24 < 10
            ? '0${endHourLocal - 24}'
            : '${endHourLocal - 24}';
        final WorkingHoursStartEnd workingHourLocal = WorkingHoursStartEnd(
            '00:$startMinutes', '$endLocalFormat:$endMinutes');
        next.hours.add(workingHourLocal);
      }
      if (sameDayHourStart != '' || sameDayHourEnd != '') {
        dev.log('same');
        final WorkingHoursStartEnd workingHourLocal = WorkingHoursStartEnd(
            '$sameDayHourStart:$startMinutes', '$sameDayHourEnd:$endMinutes');
        current.hours.add(workingHourLocal);
      }
    }).toList();
  }

  WorkingHours.fromJson(Map<String, dynamic> json) {
    int timeZoneOffset = DateTime.now().timeZoneOffset.inHours;
    /*
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
    */
    try {
      monday = WorkingHoursStartEndList([]);
      tuesday = WorkingHoursStartEndList([]);
      wednesday = WorkingHoursStartEndList([]);
      thursday = WorkingHoursStartEndList([]);
      friday = WorkingHoursStartEndList([]);
      saturday = WorkingHoursStartEndList([]);
      sunday = WorkingHoursStartEndList([]);
      if (json['monday'] != null) {
        _workingHoursToLocal(
            json: json['monday'],
            timeOffset: timeZoneOffset,
            current: monday,
            prev: sunday,
            next: tuesday);
      } else {
        monday = WorkingHoursStartEndList([]);
      }

      if (json['tuesday'] != null) {
        _workingHoursToLocal(
            json: json['tuesday'],
            timeOffset: timeZoneOffset,
            current: tuesday,
            prev: monday,
            next: wednesday);
      } else {
        tuesday = WorkingHoursStartEndList([]);
      }
      if (json['wednesday'] != null) {
        _workingHoursToLocal(
            json: json['tuesday'],
            timeOffset: timeZoneOffset,
            current: wednesday,
            prev: tuesday,
            next: thursday);
      } else {
        wednesday = WorkingHoursStartEndList([]);
      }
      if (json['thursday'] != null) {
        _workingHoursToLocal(
            json: json['tuesday'],
            timeOffset: timeZoneOffset,
            current: thursday,
            prev: wednesday,
            next: friday);
      } else {
        thursday = WorkingHoursStartEndList([]);
      }
      if (json['friday'] != null) {
        _workingHoursToLocal(
            json: json['tuesday'],
            timeOffset: timeZoneOffset,
            current: friday,
            prev: thursday,
            next: saturday);
      } else {
        friday = WorkingHoursStartEndList([]);
      }
      if (json['saturday'] != null) {
        _workingHoursToLocal(
            json: json['saturday'],
            timeOffset: timeZoneOffset,
            current: saturday,
            prev: friday,
            next: sunday);
      } else {
        saturday = WorkingHoursStartEndList([]);
      }
      if (json['sunday'] != null) {
        _workingHoursToLocal(
            json: json['sunday'],
            timeOffset: timeZoneOffset,
            current: sunday,
            prev: saturday,
            next: monday);
      } else {
        sunday = WorkingHoursStartEndList([]);
      }
    } catch (error) {
      dev.log(error.toString());
    }
  }

  List<Map<String, dynamic>> toList() {
    List<Map<String, dynamic>> wHours = [];
    if (monday.hours.isNotEmpty) {
      wHours.add({'day': 'monday', 'startEnd': monday});
    }
    if (tuesday.hours.isNotEmpty) {
      wHours.add({'day': 'tuesday', 'startEnd': tuesday});
    }
    if (wednesday.hours.isNotEmpty) {
      wHours.add({'day': 'wednesday', 'startEnd': wednesday});
    }
    if (thursday.hours.isNotEmpty) {
      wHours.add({'day': 'thursday', 'startEnd': thursday});
    }
    if (friday.hours.isNotEmpty) {
      wHours.add({'day': 'friday', 'startEnd': friday});
    }
    if (saturday.hours.isNotEmpty) {
      wHours.add({'day': 'saturday', 'startEnd': saturday});
    }
    if (sunday.hours.isNotEmpty) {
      wHours.add({'day': 'sunday', 'startEnd': sunday});
    }
    return wHours;
  }

  WorkingHours.mock() {
    monday = WorkingHoursStartEndList([]);
    tuesday = WorkingHoursStartEndList([]);
    wednesday = WorkingHoursStartEndList([]);
    thursday = WorkingHoursStartEndList([]);
    friday = WorkingHoursStartEndList([]);
    saturday = WorkingHoursStartEndList([]);
    sunday = WorkingHoursStartEndList([]);
  }
}

class WorkingHoursStartEndList {
  late List<WorkingHoursStartEnd?> hours;

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
