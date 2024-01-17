class ShowSearchObject {
  String? name;
  int? cinemaId;
  int? PageNumber;
  int? PageSize;

  ShowSearchObject({
    this.name,
    this.PageNumber,
    this.PageSize,
    this.cinemaId
  });

  ShowSearchObject.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    cinemaId = json['cinemaId'];
    PageNumber = json['pageNumber'];
    PageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name']= name;
    data['cinemaId']= cinemaId;
    data['PageNumber']= PageNumber;
    data['PageSize']= PageSize;
    return data;
  }
}