import 'package:ecinema_admin/models/seats.dart';
import 'package:ecinema_admin/models/shows.dart';
import 'package:ecinema_admin/models/user.dart';

class Reservation {
  late int id;
  late int userId;
  late int showId;
  late int seatId;
  late Shows show;
  late Seats seat;
  late User user;
  late bool isActive = false;
  late bool isConfirm = false;

  Reservation(
      {required this.id,
      required this.userId,
      required this.showId,
      required this.show,
      required this.seat,
      required this.seatId,
      required this.isActive,
      required this.user,
      required this.isConfirm});

  Reservation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    showId = json['showId'];
    seatId = json['seatId'];
    show = Shows.fromJson(json['show']);
    seat = Seats.fromJson(json['seat']);
    user = User.fromJson(json['user']);
    isActive = json['isActive'];
    isConfirm = json['isConfirm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['showId'] = showId;
    data['seatId'] = seatId;
    return data;
  }
}
