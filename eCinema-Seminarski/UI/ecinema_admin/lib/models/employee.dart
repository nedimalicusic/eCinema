import 'package:ecinema_admin/models/photo.dart';

class Employee {
  late int id;
  late String firstName;
  late String lastName;
  late String email;
  late String birthDate;
  late int gender;
  late bool isActive;
  late int? profilePhotoId;
  late int cinemaId;
  late Photo? profilePhoto;
  late bool isSelected = false;

  Employee({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.birthDate,
    required this.gender,
    required this.isActive,
    this.profilePhotoId,
    required this.cinemaId,
    this.profilePhoto,
    required this.isSelected,
  });

  Employee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    birthDate = json['birthDate'];
    gender = json['gender'];
    isActive = json['isActive'];
    profilePhotoId = json['profilePhotoId'];
    cinemaId = json['cinemaId'];
    if (json['profilePhoto'] != null) {
      profilePhoto = Photo.fromJson(json['profilePhoto']);
    } else {
      profilePhoto = null;
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['birthDate'] = birthDate;
    data['gender'] = gender;
    data['isActive'] = isActive;
    data['profilePhotoId'] = profilePhotoId;
    data['cinemaId'] = cinemaId;
    return data;
  }
}
