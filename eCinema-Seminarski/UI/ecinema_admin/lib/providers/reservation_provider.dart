import 'dart:convert';
import '../helpers/constants.dart';
import '../models/reservation.dart';
import '../models/searchObject/reservation_search.dart';
import '../utils/authorzation.dart';
import 'base_provider.dart';
import 'package:http/http.dart' as http;

class ReservationProvider extends BaseProvider<Reservation> {
  ReservationProvider() : super('Reservation/GetPaged');

  Future<dynamic> edit(dynamic resource) async {
    var uri = Uri.parse('$apiUrl/Reservation');
    Map<String, String> headers = Authorization.createHeaders();

    var jsonRequest = jsonEncode(resource);
    var response = await http.put(uri, headers: headers, body: jsonRequest);

    if (response.statusCode == 200) {
      return "OK";
    } else {
      throw Exception('Greška prilikom unosa');
    }
  }

  Future<List<Reservation>> getPaged(
      {ReservationSearchObject? searchObject}) async {
    var uri = Uri.parse('$apiUrl/Reservation/GetPaged');
    var headers = Authorization.createHeaders();
    final Map<String, String> queryParameters = {};

    if (searchObject != null) {
      if (searchObject.name != null) {
        queryParameters['name'] = searchObject.name!;
      }
      if (searchObject.cinemaId != null) {
        queryParameters['cinemaId'] = searchObject.cinemaId.toString();
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
      return items.map((d) => fromJson(d)).cast<Reservation>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> delete(int id) async {
    var uri = Uri.parse('$apiUrl/Reservation/$id');
    Map<String, String> headers = Authorization.createHeaders();

    var response = await http.delete(uri, headers: headers);

    if (response.statusCode == 200) {
      return "OK";
    } else {
      throw Exception('Greška prilikom unosa');
    }
  }

  @override
  Reservation fromJson(data) {
    return Reservation.fromJson(data);
  }
}
