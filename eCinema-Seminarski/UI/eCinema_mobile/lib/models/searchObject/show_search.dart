class ShowSearchObject {
  String? name;
  DateTime? date;
  int? cinemaId;
  int? movieId;
  int? pageNumber;
  int? pageSize;

  ShowSearchObject({
    this.name,
    this.date,
    this.cinemaId,
    this.movieId,
    this.pageNumber,
    this.pageSize,
  });

  ShowSearchObject.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    date = json['date'];
    cinemaId = json['cinemaId'];
    movieId = json['movieId'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['date'] = date;
    data['cinemaId'] = cinemaId;
    data['movieId'] = movieId;
    data['pageNumber'] = pageNumber;
    data['pageSize'] = pageSize;
    return data;
  }
}
