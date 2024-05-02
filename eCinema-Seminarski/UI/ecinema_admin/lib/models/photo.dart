class Photo {
  late String? contentType;
  late String? guidId;

  Photo({this.contentType, this.guidId});

  Photo.fromJson(Map<String, dynamic> json) {
    contentType = json['contentType'];
    guidId = json['guidId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['contentType'] = contentType;
    return data;
  }
}
