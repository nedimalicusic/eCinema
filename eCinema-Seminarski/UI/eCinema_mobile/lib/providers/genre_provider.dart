
import 'dart:convert';

import '../helpers/constants.dart';
import '../models/genre.dart';
import '../utils/authorization.dart';
import 'base_provider.dart';
import 'package:http/http.dart' as http;

class GenreProvider extends BaseProvider<Genre> {
  GenreProvider() : super('Genre/GetPaged');

  @override
  Future<Genre> getById(int id) async {
    var uri = Uri.parse('$apiUrl/Genre/$id');

    var headers = Authorization.createHeaders();

    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return fromJson(data);
    } else {
      throw Exception('Failed to load data');
    }
  }
  @override
  Genre fromJson(data) {
    return Genre.fromJson(data);
  }
}
