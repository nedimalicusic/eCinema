import 'dart:convert';

import 'package:ecinema_mobile/models/seats.dart';
import '../helpers/constants.dart';
import '../utils/authorization.dart';
import 'base_provider.dart';
import 'package:http/http.dart' as http;

class SeatsProvider extends BaseProvider<Seats> {
  SeatsProvider() : super('Seat/GetPaged');

  Future<List<Seats>> getPaged() async {
    var uri = Uri.parse('$apiUrl/Seat/GetPaged');
    var headers = Authorization.createHeaders();
    final Map<String, String> queryParameters = {};

    var pageNumber = 1;
    var pageSize = 100;
    queryParameters['pageNumber'] = pageNumber.toString();
    queryParameters['pageSize'] = pageSize.toString();

    uri = uri.replace(queryParameters: queryParameters);
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var items = data['items'];
      return items.map((d) => fromJson(d)).cast<Seats>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Seats fromJson(data) {
    return Seats.fromJson(data);
  }
}
