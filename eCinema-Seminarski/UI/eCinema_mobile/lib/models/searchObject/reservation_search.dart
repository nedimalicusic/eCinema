class ReservationObjectModel {
  int? showId;
  int? userId;

  ReservationObjectModel({
    this.showId,
    this.userId,
  });

  ReservationObjectModel.fromJson(Map<String, dynamic> json) {
    showId = json['showId'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['showId'] = showId;
    data['userId'] = userId;
    return data;
  }
}
