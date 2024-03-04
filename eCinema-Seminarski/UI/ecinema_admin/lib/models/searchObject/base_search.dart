// ignore_for_file: non_constant_identifier_names

abstract class BaseSearchObject {
  int? PageNumber;
  int? PageSize;

  BaseSearchObject({
    this.PageNumber,
    this.PageSize,
  });

  BaseSearchObject.fromJson(Map<String, dynamic> json) {
    PageNumber = json['pageNumber'];
    PageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['pageNumber'] = PageNumber;
    data['pageSize'] = PageSize;
    return data;
  }
}
