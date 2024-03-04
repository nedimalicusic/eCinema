class UserSearchObject {
  String? name;
  int? gender;
  int? role;
  bool? isActive;
  bool? isVerified;
  int? pageNumber;
  int? pageSize;

  UserSearchObject(
      {this.name,
      this.gender,
      required this.role,
      this.pageNumber,
      this.pageSize,
      this.isActive,
      this.isVerified});

  UserSearchObject.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    gender = json['gender'];
    role = json['role'];
    isActive = json['isActive'];
    isVerified = json['isVerified'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['gender'] = gender;
    data['role'] = role;
    data['isActive'] = isActive;
    data['isVerified'] = isVerified;
    data['pageNumber'] = pageNumber;
    data['pageSize'] = pageSize;
    return data;
  }
}
