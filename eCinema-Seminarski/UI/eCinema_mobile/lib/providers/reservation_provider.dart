import 'dart:convert';

import 'package:ecinema_mobile/models/reservation.dart';
import 'package:ecinema_mobile/models/searchObject/reservation_search.dart';
import 'package:ecinema_mobile/models/seats.dart';
import 'package:ecinema_mobile/models/shows.dart';

import '../helpers/constants.dart';
import '../utils/authorization.dart';
import 'base_provider.dart';
import 'package:http/http.dart' as http;

class ReservationProvider extends BaseProvider<Reservation> {
  ReservationProvider() : super('Reservation/GetPaged');

  var _selectedSeats = <Seats>[];
  Shows? _shows;

  setSelectedSeats(List<Seats> seats) {
    _selectedSeats = seats;
  }

  setProjection(Shows shows) {
    _shows = shows;
  }

  get selectedTicketTotalPrice => _shows!.price * _selectedSeats.length;

  List<Seats> get selectedSeats => _selectedSeats;
  Shows? get shows => _shows;

  Future<List<Reservation>> getByUserId(int userId) async {
    var uri = Uri.parse('$apiUrl/Reservation/GetByUserId?userId=$userId');
    var headers = Authorization.createHeaders();

    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data.map((d) => fromJson(d)).cast<Reservation>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Reservation>> getPaged(
      {ReservationObjectModel? searchObject}) async {
    var uri = Uri.parse('$apiUrl/Reservation/GetPaged');
    var headers = Authorization.createHeaders();
    final Map<String, String> queryParameters = {};

    if (searchObject != null) {
      if (searchObject.showId != null) {
        queryParameters['showId'] = searchObject.showId.toString();
      }
      if (searchObject.userId != null) {
        queryParameters['userId'] = searchObject.userId.toString();
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

  Future<List<Reservation>> getByShowId(int showId) async {
    var uri = Uri.parse('$apiUrl/Reservation/GetByShowId?showId=$showId');
    var headers = Authorization.createHeaders();
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data.map((d) => fromJson(d)).cast<Reservation>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Future<dynamic> insert(dynamic resource) async {
    var uri = Uri.parse('$apiUrl/Reservation/PostAsync');
    Map<String, String> headers = Authorization.createHeaders();

    var jsonRequest = jsonEncode(resource);
    var response = await http.post(uri, headers: headers, body: jsonRequest);
    if (response.statusCode == 200) {
      return "OK";
    }
    return "Greska prilikom kreiranja rezervacije!";
  }

  @override
  Reservation fromJson(data) {
    return Reservation.fromJson(data);
  }
}
