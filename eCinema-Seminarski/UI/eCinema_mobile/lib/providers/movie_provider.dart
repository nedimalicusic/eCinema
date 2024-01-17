import 'dart:convert';
import 'package:ecinema_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import '../helpers/constants.dart';
import '../models/movie.dart';
import '../utils/authorization.dart';

class MovieProvider extends BaseProvider<Movie> {
  MovieProvider() : super('Movie/GetPaged');

  Future<List<Movie>> getMostWatchedMovies(int size) async {
    var uri = Uri.parse('$apiUrl/Movie/GetMostWatchedMovies?size=${size}');
    var headers = Authorization.createHeaders();
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data.map((d) => fromJson(d)).cast<Movie>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
  Future<List<Movie>> getLastAddMovies(int size) async {
    var uri = Uri.parse('$apiUrl/Movie/GetLastAddMovies?size=${size}');
    var headers = Authorization.createHeaders();
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data.map((d) => fromJson(d)).cast<Movie>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }


  @override
  Movie fromJson(data) {
    return Movie.fromJson(data);
  }
}