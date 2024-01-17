class Photo {
  late String? data;
  late String? contentType;
  late String? guidId;

  Photo({this.data, this.contentType, this.guidId});

  Photo.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    contentType = json['contentType'];
    guidId = json['guidId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = data;
    data['contentType'] = contentType;
    return data;
  }
}
