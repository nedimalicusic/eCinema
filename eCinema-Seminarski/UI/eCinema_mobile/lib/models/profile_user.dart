import 'package:ecinema_mobile/models/photo.dart';

class ProfileUser {
  late int id;
  late String firstName;
  late String lastName;
  late String? phoneNumber;
  late String birthDate;
  late String email;
  late int? profilePhotoId;
  late int? role;
  late int gender;
  late bool isActive;
  late bool isVerified;
  late Photo? profilePhoto;
  late bool isSelected = false;

  ProfileUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.isActive,
    required this.isVerified,
    required this.birthDate,
    this.phoneNumber,
    this.profilePhotoId,
    this.role,
    this.profilePhoto,
    required this.isSelected,
  });

  ProfileUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    profilePhotoId = json['profilePhotoId'];
    role = json['role'];
    gender = json['gender'];
    isActive = json['isActive'];
    isVerified = json['isVerified'];
    birthDate = json['birthDate'];
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
    data['email'] = email;
    data['profilePhotoId'] = profilePhotoId;
    data['role'] = role;
    data['gender'] = gender;
    data['isActive'] = isActive;
    data['isVerified'] = isVerified;
    data['birthDate'] = birthDate;
    return data;
  }
}
