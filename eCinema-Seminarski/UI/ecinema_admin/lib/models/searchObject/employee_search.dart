class EmployeeSearchObject {
  String? name;
  int? gender;
  bool? isActive;
  int? cinemaId;
  int? pageNumber;
  int? pageSize;

  EmployeeSearchObject(
      {this.name,
      this.gender,
      this.pageNumber,
      this.pageSize,
      this.isActive,
      this.cinemaId});

  EmployeeSearchObject.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    gender = json['gender'];
    isActive = json['isActive'];
    cinemaId = json['cinemaId'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['gender'] = gender;
    data['isActive'] = isActive;
    data['cinemaId'] = cinemaId;
    data['pageNumber'] = pageNumber;
    data['pageSize'] = pageSize;
    return data;
  }
}
