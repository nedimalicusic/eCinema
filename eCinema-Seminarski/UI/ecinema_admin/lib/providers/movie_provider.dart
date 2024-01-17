import '../helpers/constants.dart';
import '../models/movie.dart';
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
