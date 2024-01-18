import 'dart:convert';

import '../helpers/constants.dart';
import '../models/movie.dart';
import '../models/searchObject/movie_search.dart';
import '../utils/authorzation.dart';
import 'base_provider.dart';
import 'package:http/http.dart' as http;

class MovieProvider extends BaseProvider<Movie> {
  MovieProvider() : super('Movie/GetPaged');

  Future<dynamic> delete(int id) async {
    var uri = Uri.parse('$apiUrl/Movie/$id');
    Map<String, String> headers = Authorization.createHeaders();

    var response = await http.delete(uri, headers: headers);
    if (response.statusCode == 200) {
      return "OK";
    } else {
      throw Exception('Greška prilikom unosa');
    }
  }

  Future<List<Movie>> getPaged({MovieSearchObject? searchObject}) async {
    var uri = Uri.parse('$apiUrl/Movie/GetPaged');
    var headers = Authorization.createHeaders();
    final Map<String, String> queryParameters = {};

    if (searchObject != null) {
      if (searchObject.name != null) {
        queryParameters['name'] = searchObject.name!;
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
      return items.map((d) => fromJson(d)).cast<Movie>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> insertMovie(Map<String, dynamic> userData) async {
    try {
      var uri = Uri.parse('$apiUrl/Movie/insertMovie');

      var request = http.MultipartRequest('POST', uri);

      var stringUserData =
          userData.map((key, value) => MapEntry(key, value.toString()));

      request.fields.addAll(stringUserData);

      if (userData.containsKey('photo')) {
        request.files.add(userData['photo']);
      }

      var response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        return "OK";
      } else {
        throw Exception('Error inserting movie: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error inserting movie: $e');
    }
  }

  Future<dynamic> updateMovie(Map<String, dynamic> updatedUserData) async {
    try {
      var uri = Uri.parse('$apiUrl/Movie/updateMovie');

      var request = http.MultipartRequest('PUT', uri);

      var stringUpdatedUserData =
          updatedUserData.map((key, value) => MapEntry(key, value.toString()));

      request.fields.addAll(stringUpdatedUserData);

      if (updatedUserData.containsKey('photo')) {
        request.files.add(updatedUserData['photo']);
      }

      var response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        return "OK";
      } else {
        throw Exception('Error updating movie: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating movie: $e');
    }
  }

  @override
  Movie fromJson(data) {
    return Movie.fromJson(data);
  }
}
