class CinemaSearchObject {
  String? name;
  int? PageNumber;
  int? PageSize;

  CinemaSearchObject({
    this.name,
    this.PageNumber,
    this.PageSize,
  });

  CinemaSearchObject.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    PageNumber = json['pageNumber'];
    PageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name']= name;
    data['PageNumber']= PageNumber;
    data['PageSize']= PageSize;
    return data;
  }
}