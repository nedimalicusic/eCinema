import 'package:ecinema_admin/models/week_day.dart';

class ReccuringShow {
  late int id;
  late DateTime startingDate;
  late DateTime endingDate;
  late int weekDayId;

  ReccuringShow({
    required this.id,
    required this.startingDate,
    required this.endingDate,
    required this.weekDayId,
  });

  ReccuringShow.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startingDate = DateTime.parse(json['startingDate']);
    endingDate = DateTime.parse(json['endingDate']);
    weekDayId = json['weekDayId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['startingDate'] = startingDate;
    data['endingDate'] = endingDate;
    data['weekDayId'] = weekDayId;
    return data;
  }
}
