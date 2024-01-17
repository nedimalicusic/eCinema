
import 'package:ecinema_mobile/models/city.dart';


class Cinema {
  late int id;
  late String name;
  late String address;
  late String description;
  late String email;
  late int phoneNumber;
  late int numberOfSeats;
  late int cityId;
  late City city;

  Cinema(
      {required this.id,
        required this.name,
        required this.address,
        required this.description,
        required this.email,
        required this.phoneNumber,
        required this.cityId,
        required this.city,
        required this.numberOfSeats});

  Cinema.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    description = json['description'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    cityId = json['cityId'];
    city = City.fromJson(json['city']);
    numberOfSeats = json['numberOfSeats'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['description'] = description;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['numberOfSeats'] = numberOfSeats;
    data['cityId'] = cityId;

    return data;
  }
}
