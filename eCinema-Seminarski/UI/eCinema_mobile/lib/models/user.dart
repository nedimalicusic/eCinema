
class User {
  User({
    required this.Id,
    required this.FirstName,
    required this.LastName,
    required this.Email,
    this.PhoneNumber,
    this.profilePhotoId,
    this.token,
    this.Role,
  });
  late String Id;
  late String FirstName;
  late String LastName;
  late String? PhoneNumber;
  late String Email;
  late String? profilePhotoId;
  late String? token;
  late String? Role;

  User.fromJson(Map<String, dynamic> json) {
    Id = json['Id'];
    FirstName = json['FirstName'];
    LastName = json['LastName'];
    PhoneNumber = json['PhoneNumber'];
    Email = json['Email'];
    profilePhotoId = json['profilePhotoId'];
    token = json['token'];
    Role = json['Role'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Id'] = Id;
    data['FirstName'] = FirstName;
    data['LastName'] = LastName;
    data['PhoneNumber'] = PhoneNumber;
    data['Email'] = Email;
    data['profilePhotoId'] = profilePhotoId;
    data['token'] = token;
    data['Role'] = Role;
    return data;
  }

}
