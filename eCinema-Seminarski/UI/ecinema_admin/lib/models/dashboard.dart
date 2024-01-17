class Dashboard {
  late int countUsers;
  late int countUsersActive;
  late int countUsersInActive;
  late int countEmployees;
  late int countOfReservation;

  Dashboard(
      {required this.countUsers,
      required this.countUsersActive,
      required this.countUsersInActive,
      required this.countEmployees,
      required this.countOfReservation});

  Dashboard.fromJson(Map<String, dynamic> json) {
    countUsers = json['countUsers'];
    countUsersActive = json['countUsersActive'];
    countUsersInActive = json['countUsersInActive'];
    countEmployees = json['countEmployees'];
    countOfReservation = json['countOfReservation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['countUsers'] = countUsers;
    data['countUsersActive'] = countUsersActive;
    data['countUsersInActive'] = countUsersInActive;
    data['countEmployees'] = countEmployees;
    data['countOfReservation'] = countOfReservation;
    return data;
  }
}
