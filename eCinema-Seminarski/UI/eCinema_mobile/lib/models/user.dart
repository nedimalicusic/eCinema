import 'package:ecinema_mobile/models/photo.dart';

class User {
  late int id;
  late String firstName;
  late String lastName;
  late String? phoneNumber;
  late String? birthDate;
  late String email;
  late String? password;
  late String? token;
  late int? role;
  late int gender;
  late bool isActive;
  late bool isVerified;
  late Photo? profilePhoto;
  late int? profilePhotoId;
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
    this.birthDate,
    this.phoneNumber,
    this.token,
    this.role,
    this.profilePhoto,
    this.profilePhotoId,
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
    birthDate = json['birthDate'];
    profilePhotoId = json['profilePhotoId'];
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
    data['phoneNumber'] = phoneNumber;
    data['password'] = password;
    data['email'] = email;
    data['profilePhotoId'] = profilePhotoId;
    data['token'] = token;
    data['role'] = role;
    data['gender'] = gender;
    data['isActive'] = isActive;
    data['isVerified'] = isVerified;
    data['birthDate'] = birthDate;
    return data;
  }
}
