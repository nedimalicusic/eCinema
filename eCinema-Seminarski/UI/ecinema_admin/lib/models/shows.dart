import 'package:ecinema_admin/models/reccuring_show.dart';
import 'package:ecinema_admin/models/show_type.dart';

import 'cinema.dart';
import 'movie.dart';

class Shows {
  late int id;
  late DateTime startsAt;
  late DateTime endsAt;
  late int price;
  late int cinemaId;
  late Cinema cinema;
  late int movieId;
  late Movie movie;
  late int showTypeId;
  late ShowType showType;
  late int? recurringShowId;
  late ReccuringShow? reccuringShow;
  late bool isSelected = false;

  Shows(
      {required this.id,
      required this.startsAt,
      required this.endsAt,
      required this.price,
      required this.cinemaId,
      required this.cinema,
      required this.movieId,
      required this.movie,
      required this.showTypeId,
      required this.showType,
      this.recurringShowId,
      this.reccuringShow,
      required this.isSelected});

  Shows.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startsAt = DateTime.parse(json['startsAt']);
    endsAt = DateTime.parse(json['endsAt']);
    price = json['price'];
    cinemaId = json['cinemaId'];
    cinema = Cinema.fromJson(json['cinema']);
    movieId = json['movieId'];
    movie = Movie.fromJson(json['movie']);
    recurringShowId = json['recurringShowId'];
    reccuringShow = json['reccuringShow'] == null
        ? null
        : ReccuringShow.fromJson(json['reccuringShow']);
    showTypeId = json['showTypeId'];
    showType = ShowType.fromJson(json['showType']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['startsAt'] = startsAt;
    data['endsAt'] = endsAt;
    data['price'] = price;
    data['cinemaId'] = cinemaId;
    data['movieId'] = movieId;
    data['recurringShowId'] = recurringShowId;
    return data;
  }
}
