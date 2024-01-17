import 'cinema.dart';
import 'movie.dart';

class Shows {
  late int id;
  late DateTime date;
  late DateTime startTime;
  late String format;
  late int cinemaId;
  late int movieId;
  late Movie movie;
  late Cinema cinema;
  late double price;

  Shows(
      {required this.id,
        required this.date,
        required this.startTime,
        required this.format,
        required this.cinemaId,
        required this.movieId,
        required this.movie,
        required this.price,
        required this.cinema
   });

  Shows.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = DateTime.parse(json['date']);
    startTime = DateTime.parse(json['startTime']);
    format = json['format'];
    cinemaId = json['cinemaId'];
    movieId = json['movieId'];
    price = json['price'];
    movie = Movie.fromJson(json['movie']);
    cinema = Cinema.fromJson(json['cinema']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['startTime'] = startTime;
    data['format'] = format;
    data['cinemaId'] = cinemaId;
    data['movieId'] = movieId;
    data['price'] = price;
    return data;
  }
}
