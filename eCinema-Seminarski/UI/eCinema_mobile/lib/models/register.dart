class Register {
  late String firstName;
  late String lastName;
  late String email;
  late String phoneNumber;
  late String password;

  Register({
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }
}
