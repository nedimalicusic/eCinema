import 'dart:convert';
import 'package:ecinema_admin/models/searchObject/show_search.dart';
import 'package:ecinema_admin/models/shows.dart';
import '../helpers/constants.dart';
import '../utils/authorzation.dart';
import 'base_provider.dart';
import 'package:http/http.dart' as http;

class ShowProvider extends BaseProvider<Shows> {
  ShowProvider() : super('Show/GetPaged');

  Future<List<Shows>> getPaged({ShowSearchObject? searchObject}) async {
    var uri = Uri.parse('$apiUrl/Show/GetPaged');
    var headers = Authorization.createHeaders();
    final Map<String, String> queryParameters = {};

    if (searchObject != null) {
      if (searchObject.name != null) {
        queryParameters['name'] = searchObject.name!;
      }
      if (searchObject.cinemaId != null) {
        queryParameters['cinemaId'] = searchObject.cinemaId.toString();
      }
      if (searchObject.PageNumber != null) {
        queryParameters['pageNumber'] = searchObject.PageNumber.toString();
      }
      if (searchObject.PageSize != null) {
        queryParameters['pageSize'] = searchObject.PageSize.toString();
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
  Future<dynamic> insert(dynamic resource) async {
    var uri = Uri.parse('$apiUrl/Show');
    Map<String, String> headers = Authorization.createHeaders();

    var jsonRequest = jsonEncode(resource);
    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (response.statusCode == 200) {
      return "OK";
    } else {
      throw Exception('Greška prilikom unosa');
    }
  }

  Future<dynamic> edit(dynamic resource) async {
    var uri = Uri.parse('$apiUrl/Show');
    Map<String, String> headers = Authorization.createHeaders();

    var jsonRequest = jsonEncode(resource);
    var response = await http.put(uri, headers: headers, body: jsonRequest);

    if (response.statusCode == 200) {
      return "OK";
    } else {
      throw Exception('Greška prilikom unosa');
    }
  }

  Future<dynamic> delete(int id) async {
    var uri = Uri.parse('$apiUrl/Show/${id}');
    Map<String, String> headers = Authorization.createHeaders();

    var response = await http.delete(uri, headers: headers);

    if (response.statusCode == 200) {
      return "OK";
    } else {
      throw Exception('Greška prilikom unosa');
    }
  }

  @override
  Shows fromJson(data) {
    return Shows.fromJson(data);
  }
}
