class Seats {
  late int id;
  late int column;
  late String row;
  late bool isReserved = false;
  late bool isSelected = false;

  Seats({required this.id,
    required this.column,
    required this.row});

  Seats.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    column = json['column'];
    row = json['row'];
    isReserved = false;
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['column'] = column;
    data['row'] = row;
    return data;
  }

  @override
  String toString() {
    return '$row$column';
  }
}
