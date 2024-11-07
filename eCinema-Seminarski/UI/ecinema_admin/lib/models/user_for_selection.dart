class UserForSelection {
  late int id;
  late String firstName;
  late String lastName;

  UserForSelection({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  UserForSelection.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    firstName = json['firstName'] as String;
    lastName = json['lastName'] as String;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;

    return data;
  }
}
