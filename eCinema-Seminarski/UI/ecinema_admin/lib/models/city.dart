import 'package:ecinema_admin/models/country.dart';

class City {
  late int id;
  late String name;
  late String zipCode;
  late bool isActive;
  late int countryId;
  late Country country;

  City(
      {required this.id,
      required this.name,
      required this.zipCode,
      required this.isActive,
      required this.countryId,
      required this.country});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    zipCode = json['zipCode'];
    isActive = json['isActive'];
    countryId = json['countryId'];
    country = Country.fromJson(json['country']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['zipCode'] = zipCode;
    data['isActive'] = isActive;
    data['countryId'] = countryId;
    data['country'] = country;
    return data;
  }
}
