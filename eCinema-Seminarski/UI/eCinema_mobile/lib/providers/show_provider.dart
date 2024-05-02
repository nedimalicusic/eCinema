import 'dart:convert';

import 'package:ecinema_mobile/models/searchObject/show_search.dart';
import 'package:ecinema_mobile/models/shows.dart';

import '../helpers/constants.dart';
import '../utils/authorization.dart';
import 'base_provider.dart';
import 'package:http/http.dart' as http;

class ShowProvider extends BaseProvider<Shows> {
  ShowProvider() : super('Show/GetPaged');

  Future<List<Shows>> getByMovieId(int movieId) async {
    var uri = Uri.parse('$apiUrl/Show/GetByMovieId?movieId=$movieId');
    var headers = Authorization.createHeaders();

    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data.map((d) => fromJson(d)).cast<Shows>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Shows>> getByGenreId(int? genreId, int cinemaId) async {
    var uri = Uri.parse(
        '$apiUrl/Show/GetByGenreId?genreId=$genreId&cinemaId=$cinemaId');
    var headers = Authorization.createHeaders();

    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data.map((d) => fromJson(d)).cast<Shows>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Shows>> getLastAddShows(int size, int cinemaId) async {
    var uri =
        Uri.parse('$apiUrl/Show/GetLastAddShows?size=$size&cinemaId=$cinemaId');
    var headers = Authorization.createHeaders();

    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data.map((d) => fromJson(d)).cast<Shows>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Shows>> getMostWatchedShows(int size, int cinemaId) async {
    var uri = Uri.parse(
        '$apiUrl/Show/GetMostWatchedShows?size=$size&cinemaId=$cinemaId');
    var headers = Authorization.createHeaders();

    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data.map((d) => fromJson(d)).cast<Shows>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Shows>> getPaged({ShowSearchObject? searchObject}) async {
    var uri = Uri.parse('$apiUrl/Show/GetPaged');
    var headers = Authorization.createHeaders();
    final Map<String, String> queryParameters = {};

    if (searchObject != null) {
      if (searchObject.date != null) {
        queryParameters['date'] = searchObject.date.toString();
      }
      if (searchObject.cinemaId != null) {
        queryParameters['cinemaId'] = searchObject.cinemaId.toString();
      }
      if (searchObject.movieId != null) {
        queryParameters['movieId'] = searchObject.movieId.toString();
      }
      if (searchObject.pageNumber != null) {
        queryParameters['pageNumber'] = searchObject.pageNumber.toString();
      }
      if (searchObject.pageSize != null) {
        queryParameters['pageSize'] = searchObject.pageSize.toString();
      }
    }

    uri = uri.replace(queryParameters: queryParameters);
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var items = data['items'];
      return items.map((d) => fromJson(d)).cast<Shows>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Shows fromJson(data) {
    return Shows.fromJson(data);
  }
}
