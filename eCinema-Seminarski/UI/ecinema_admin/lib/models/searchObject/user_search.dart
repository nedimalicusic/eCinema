class UserSearchObject {
  String? name;
  int? gender;
  bool? isActive;
  bool? isVerified;
  int? PageNumber;
  int? PageSize;

  UserSearchObject({
    this.name,
    this.gender,
    this.PageNumber,
    this.PageSize,
    this.isActive,
    this.isVerified
  });

  UserSearchObject.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    gender = json['gender'];
    isActive = json['isActive'];
    isVerified = json['isVerified'];
    PageNumber = json['pageNumber'];
    PageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name']= name;
    data['gender']= gender;
    data['isActive']= isActive;
    data['isVerified']= isVerified;
    data['PageNumber']= PageNumber;
    data['PageSize']= PageSize;
    return data;
  }
}