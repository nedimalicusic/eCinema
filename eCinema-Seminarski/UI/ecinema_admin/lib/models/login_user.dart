class UserLogin {
  late String id;
  late String firstName;
  late String lastName;
  late String? phoneNumber;
  late String email;
  late String? profilePhotoId;
  late String? token;
  late String? role;
  late String? guidId;

  UserLogin({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    this.profilePhotoId,
    this.token,
    this.role,
    this.guidId,
  });

  UserLogin.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    phoneNumber = json['PhoneNumber'];
    email = json['Email'];
    profilePhotoId = json['profilePhotoId'];
    token = json['token'];
    role = json['Role'];
    guidId = json['GuidId'];
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'FirstName': firstName,
      'LastName': lastName,
      'PhoneNumber': phoneNumber,
      'Email': email,
      'profilePhotoId': profilePhotoId,
      'token': token,
      'Role': role,
      'GuidId': guidId,
    };
  }
}
