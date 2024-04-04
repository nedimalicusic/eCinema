import 'package:ecinema_mobile/models/photo.dart';

class User {
  late int id;
  late String firstName;
  late String lastName;
  late String? phoneNumber;
  late String? dateOfBirth;
  late String email;
  late String? password;
  late String? token;
  late int? role;
  late int gender;
  late bool isActive;
  late bool isVerified;
  late Photo? photo;
  late int? photoId;
  late bool isSelected = false;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.isActive,
    required this.isVerified,
    this.password,
    this.dateOfBirth,
    this.phoneNumber,
    this.token,
    this.role,
    this.photo,
    this.photoId,
    required this.isSelected,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'] as String;
    lastName = json['lastName'] as String;
    phoneNumber = json['phoneNumber'];
    password = json['password'];
    email = json['email'] as String;
    token = json['token'];
    role = json['role'];
    gender = json['gender'] as int;
    isActive = json['isActive'] as bool;
    isVerified = json['isVerified'] as bool;
    dateOfBirth = json['dateOfBirth'];
    photoId = json['photoId'];
    if (json['photo'] != null) {
      photo = Photo.fromJson(json['photo']);
    } else {
      photo = null;
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['phoneNumber'] = phoneNumber;
    data['password'] = password;
    data['email'] = email;
    data['profilePhotoId'] = photoId;
    data['token'] = token;
    data['role'] = role;
    data['gender'] = gender;
    data['isActive'] = isActive;
    data['isVerified'] = isVerified;
    data['dateOfBirth'] = dateOfBirth;
    return data;
  }
}
