class NotificationUpsertModel {
  late String title;
  late String description;
  late int userId;
  late bool seen;
  late DateTime sendOnDate;
  late DateTime? dateRead;

  NotificationUpsertModel({
    required this.title,
    required this.description,
    required this.userId,
    required this.seen,
    required this.sendOnDate,
    this.dateRead,
  });
}
