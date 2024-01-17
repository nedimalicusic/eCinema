class ShowSearchObject {
  String? name;
  int? cinemaId;
  int? pageNumber;
  int? pageSize;

  ShowSearchObject({this.name, this.pageNumber, this.pageSize, this.cinemaId});

  ShowSearchObject.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    cinemaId = json['cinemaId'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['cinemaId'] = cinemaId;
    data['pageNumber'] = pageNumber;
    data['pageSize'] = pageSize;
    return data;
  }
}
