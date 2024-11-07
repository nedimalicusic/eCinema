class MovieSearchObject {
  String? name;
  int? pageNumber;
  int? pageSize;
  int? genreId;
  int? categoryId;

  MovieSearchObject(
      {this.name,
      this.pageNumber,
      this.pageSize,
      this.categoryId,
      this.genreId});

  MovieSearchObject.fromJson(Map<String, dynamic> json) {
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
