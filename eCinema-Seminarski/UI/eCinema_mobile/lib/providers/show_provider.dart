import 'dart:convert';

import 'package:ecinema_mobile/models/seats.dart';
import 'package:ecinema_mobile/models/shows.dart';

import '../helpers/constants.dart';
import '../utils/authorization.dart';
import 'base_provider.dart';
import 'package:http/http.dart' as http;

class ShowProvider extends BaseProvider<Shows> {
  ShowProvider() : super('Show/GetPaged');

  @override
  Future<List<Shows>> getByMovieId(int movieId) async {
    var uri = Uri.parse('$apiUrl/Show/GetByMovieId?movieId=${movieId}');
    var headers = Authorization.createHeaders();

    final response = await http.get(uri, headers: headers);
    print(response);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data.map((d) => fromJson(d)).cast<Shows>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
  @override
  Future<List<Shows>> getByGenreId(int? genreId,int cinemaId) async {
    var uri = Uri.parse('$apiUrl/Show/GetByGenreId?genreId=${genreId}&cinemaId=${cinemaId}');
    var headers = Authorization.createHeaders();

    final response = await http.get(uri, headers: headers);
    print(response);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data.map((d) => fromJson(d)).cast<Shows>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Future<List<Shows>> getLastAddShows(int size,int cinemaId) async {
    var uri = Uri.parse('$apiUrl/Show/GetLastAddShows?size=${size}&cinemaId=${cinemaId}');
    var headers = Authorization.createHeaders();

    final response = await http.get(uri, headers: headers);
    print(response);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data.map((d) => fromJson(d)).cast<Shows>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Future<List<Shows>> getMostWatchedShows(int size,int cinemaId) async {
    var uri = Uri.parse('$apiUrl/Show/GetMostWatchedShows?size=${size}&cinemaId=${cinemaId}');
    var headers = Authorization.createHeaders();

    final response = await http.get(uri, headers: headers);
    print(response);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data.map((d) => fromJson(d)).cast<Shows>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Shows fromJson(data) {
    return Shows.fromJson(data);
  }
}
