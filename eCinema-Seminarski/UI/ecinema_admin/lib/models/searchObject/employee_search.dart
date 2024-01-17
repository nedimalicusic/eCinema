class EmployeeSearchObject {
  String? name;
  int? gender;
  bool? isActive;
  int? cinemaId;
  int? PageNumber;
  int? PageSize;

  EmployeeSearchObject({
    this.name,
    this.gender,
    this.PageNumber,
    this.PageSize,
    this.isActive,
    this.cinemaId
  });

  EmployeeSearchObject.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    gender = json['gender'];
    isActive = json['isActive'];
    cinemaId = json['cinemaId'];
    PageNumber = json['pageNumber'];
    PageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name']= name;
    data['gender']= gender;
    data['isActive']= isActive;
    data['cinemaId']= cinemaId;
    data['PageNumber']= PageNumber;
    data['PageSize']= PageSize;
    return data;
  }
}