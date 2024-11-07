class CinemaSearchObject {
  String? name;
  int? pageNumber;
  int? pageSize;
  int? cinemaId;

  CinemaSearchObject(
      {this.name, this.pageNumber, this.pageSize, this.cinemaId});

  CinemaSearchObject.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    cinemaId = json['cinemaId'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['pageNumber'] = pageNumber;
    data['pageSize'] = pageSize;
    data['cinemaId'] = cinemaId;
    return data;
  }
}
