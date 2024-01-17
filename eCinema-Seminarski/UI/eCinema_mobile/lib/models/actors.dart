class Actors {
  final int id;
  final String firstName;
  final String lastName;

  const Actors({required this.id,
    required this.firstName,
    required this.lastName});

  factory Actors.fromJson(Map<String, dynamic> json) {
    return Actors(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    return data;
  }
}
