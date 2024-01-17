class Actor {
  late int id;
  late String firstName;
  late String lastName;
  late String email;
  late String birthDate;
  late int gender;

  Actor({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.birthDate,
    required this.gender,
  });

  Actor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    birthDate = json['birthDate'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['birthDate'] = birthDate;
    data['gender'] = gender;
    return data;
  }
}
