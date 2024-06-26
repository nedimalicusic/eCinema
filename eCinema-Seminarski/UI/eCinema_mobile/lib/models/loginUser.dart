class UserLogin {
  late String Id;
  late String FirstName;
  late String LastName;
  late String? PhoneNumber;
  late String Email;
  late String? profilePhotoId;
  late String? token;
  late String? Role;
  late String? GuidId;

  UserLogin({
    required this.Id,
    required this.FirstName,
    required this.LastName,
    required this.Email,
    this.PhoneNumber,
    this.profilePhotoId,
    this.token,
    this.Role,
    this.GuidId,
  });

  UserLogin.fromJson(Map<String, dynamic> json) {
    Id = json['Id'];
    FirstName = json['FirstName'];
    LastName = json['LastName'];
    PhoneNumber = json['PhoneNumber'];
    Email = json['Email'];
    profilePhotoId = json['profilePhotoId'];
    token = json['token'];
    Role = json['Role'];
    GuidId = json['GuidId'];
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
    data['GuidId'] = GuidId;
    return data;
  }
}
