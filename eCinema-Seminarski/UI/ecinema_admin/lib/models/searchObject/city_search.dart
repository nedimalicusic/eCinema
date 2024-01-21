class CitySearchObject {
  String? name;
  int? pageNumber;
  int? pageSize;

  CitySearchObject({this.name, this.pageNumber, this.pageSize});

  CitySearchObject.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['pageNumber'] = pageNumber;
    data['pageSize'] = pageSize;
    return data;
  }
}
