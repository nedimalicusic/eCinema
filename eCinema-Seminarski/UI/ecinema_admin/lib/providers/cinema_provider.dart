import 'dart:convert';
import 'package:ecinema_admin/models/dashboard.dart';
import 'package:ecinema_admin/models/searchObject/cinema_search.dart';
import '../helpers/constants.dart';
import '../models/cinema.dart';
import '../utils/authorzation.dart';
import 'base_provider.dart';
import 'package:http/http.dart' as http;

class CinemaProvider extends BaseProvider<Cinema> {
  CinemaProvider() : super('Cinema/GetPaged');

  late Cinema _selectedCinema;

  setSelectedCinema(Cinema cinema) {
    _selectedCinema = cinema;
  }

  getSelectCinema() {
    return _selectedCinema;
  }

  @override
  Future<dynamic> insert(dynamic resource) async {
    var uri = Uri.parse('$apiUrl/Cinema');
    Map<String, String> headers = Authorization.createHeaders();

    var jsonRequest = jsonEncode(resource);
    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (response.statusCode == 200) {
      return "OK";
    } else {
      throw Exception('Greška prilikom unosa');
    }
  }

  Future<List<Cinema>> getPaged({CinemaSearchObject? searchObject}) async {
    var uri = Uri.parse('$apiUrl/Cinema/GetPaged');
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
      return items.map((d) => fromJson(d)).cast<Cinema>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> edit(dynamic resource) async {
    var uri = Uri.parse('$apiUrl/Cinema');
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
    var uri = Uri.parse('$apiUrl/Cinema/$id');
    Map<String, String> headers = Authorization.createHeaders();

    var response = await http.delete(uri, headers: headers);

    if (response.statusCode == 200) {
      return "OK";
    } else {
      throw Exception('Greška prilikom unosa');
    }
  }

  Future<Dashboard> getDashboardInformation(int cinemaId) async {
    var uri =
        Uri.parse('$apiUrl/Cinema/GetDashboardInformation?cinemaId=$cinemaId');
    var headers = Authorization.createHeaders();
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return fromJsonDashboard(data);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Dashboard fromJsonDashboard(data) {
    return Dashboard.fromJson(data);
  }

  @override
  Cinema fromJson(data) {
    return Cinema.fromJson(data);
  }
}
