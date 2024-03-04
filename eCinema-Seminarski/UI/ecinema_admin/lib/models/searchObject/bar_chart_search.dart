import 'base_search.dart';

class BarChartSearchObject extends BaseSearchObject {
  int? year;
  int? cinemaId;

  BarChartSearchObject({this.year, this.cinemaId});

  BarChartSearchObject.fromJson(Map<String, dynamic> json) {
    year = json['year'];
    cinemaId = json['cinemaId'];
  }

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['year'] = year;
    data['cinemaId'] = cinemaId;

    return data;
  }
}
