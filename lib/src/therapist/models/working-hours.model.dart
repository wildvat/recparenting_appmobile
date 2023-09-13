class WorkingHours{
    late WorkingHoursStartEnd? monday;
    late WorkingHoursStartEnd? tuesday;
    late WorkingHoursStartEnd? wednesday;
    late WorkingHoursStartEnd? thursday;
    late WorkingHoursStartEnd? friday;
    late WorkingHoursStartEnd? saturday;
    late WorkingHoursStartEnd? sunday;

    WorkingHours(this.monday, this.tuesday, this.wednesday, this.thursday,
      this.friday, this.saturday, this.sunday);

    WorkingHours.fromJson(Map<String, dynamic> json){
        if(json['monday'] != null){
            monday = WorkingHoursStartEnd.fromList(json['monday']);
        }
        if(json['tuesday'] != null){
            tuesday = WorkingHoursStartEnd.fromList(json['tuesday']);
        }
        if(json['wednesday'] != null){
            wednesday = WorkingHoursStartEnd.fromList(json['wednesday']);
        }
        if(json['thursday'] != null){
            thursday = WorkingHoursStartEnd.fromList(json['thursday']);
        }
        if(json['friday'] != null){
            friday = WorkingHoursStartEnd.fromList(json['friday']);
        }
        if(json['saturday'] != null){
            saturday = WorkingHoursStartEnd.fromList(json['saturday']);
        }
        if(json['sunday'] != null){
            sunday = WorkingHoursStartEnd.fromList(json['sunday']);
        }
    }
/*
    toJson(){
        return {
            'monday': monday!.toJson(),
            'tuesday': tuesday!.toJson(),
            'wednesday': wednesday!.toJson(),
            'thursday': thursday!.toJson(),
            'friday': friday!.toJson(),
            'saturday': saturday!.toJson(),
            'sunday': sunday!.toJson(),
        };
    }*/
}

class WorkingHoursStartEnd{
    late String start;
    late String end;

    WorkingHoursStartEnd(this.start, this.end);

    WorkingHoursStartEnd.fromJson(Map<String, dynamic> json){
        start = json['start'];
        end = json['end'];
    }

    WorkingHoursStartEnd.fromList(List<dynamic> json){
        end = json[0]['end'];
        start = json[0]['start'];

    }
/*
    toJson(){
        return {
            'start': start,
            'end': end,
        };
    }*/
}