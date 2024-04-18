class MovieSearchObject {
  String? name;
  int? categoryId;
  int? genreId;
  int? pageNumber;
  int? pageSize;

  MovieSearchObject({
    this.name,
    this.categoryId,
    this.genreId,
    this.pageNumber,
    this.pageSize,
  });

  MovieSearchObject.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    categoryId = json['categoryId'];
    genreId = json['genreId'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['categoryId'] = categoryId;
    data['genreId'] = genreId;
    data['pageNumber'] = pageNumber;
    data['pageSize'] = pageSize;
    return data;
  }
}
