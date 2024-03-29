import 'package:ecinema_admin/models/country.dart';

class Production {
  late int id;
  late String name;
  late int countryId;
  late Country country;
  late bool isSelected = false;

  Production(
      {required this.id,
      required this.name,
      required this.countryId,
      required this.country});

  Production.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    countryId = json['countryId'];
    country = Country.fromJson(json['country']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['countryId'] = countryId;
    return data;
  }
}
