import 'dart:convert';

import 'package:ecinema_mobile/models/seats.dart';

import '../helpers/constants.dart';
import '../utils/authorization.dart';
import 'base_provider.dart';
import 'package:http/http.dart' as http;

class SeatsProvider extends BaseProvider<Seats> {
  SeatsProvider() : super('Seat/GetPaged');

  @override
  Future<List<Seats>> getbyCinemaId(int cinemaId) async {
    var uri = Uri.parse('$apiUrl/Seat/GetAllSeatsByCinemaId?cinemaId=${cinemaId}');
    var headers = Authorization.createHeaders();

    final response = await http.get(uri, headers: headers);
    print(response);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data.map((d) => fromJson(d)).cast<Seats>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
  @override
  Seats fromJson(data) {
    return Seats.fromJson(data);
  }
}
