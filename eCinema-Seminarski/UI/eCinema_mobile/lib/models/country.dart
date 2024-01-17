class Country {
  late int id;
  late String name;
  late String abbreviation;
  late bool isActive;

  Country({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.isActive,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      name: json['name'],
      abbreviation: json['abbreviation'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['abbreviation'] = abbreviation;
    data['isActive'] = isActive;
    return data;
  }
}
