class Notifications {
  late int? id;
  late String title;
  late String description;
  late int userId;
  late bool seen;
  late DateTime sendOnDate;
  late DateTime? dateRead;

  Notifications({
    this.id,
    required this.title,
    required this.description,
    required this.userId,
    required this.seen,
    required this.sendOnDate,
    this.dateRead,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      userId: json['userId'],
      seen: json['seen'],
      sendOnDate: DateTime.parse(json['sendOnDate']),
      dateRead: json['dateRead'] != null ? DateTime.parse(json['dateRead']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['userId'] = userId;
    data['seen'] = seen;
    data['sendOnDate'] = sendOnDate;
    data['dateRead'] = dateRead;
    return data;
  }
}
