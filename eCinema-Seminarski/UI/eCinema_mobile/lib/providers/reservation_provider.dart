import 'dart:convert';

import 'package:ecinema_mobile/models/reservation.dart';
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

  @override
  Future<List<Reservation>> getByUserId(int userId) async {
    var uri = Uri.parse('$apiUrl/Reservation/GetByUserId?userId=${userId}');
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
  Reservation fromJson(data) {
    return Reservation.fromJson(data);
  }
}
