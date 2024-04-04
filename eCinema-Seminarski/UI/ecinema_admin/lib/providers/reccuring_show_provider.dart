import 'dart:convert';

import 'package:ecinema_admin/models/reccuring_show.dart';

import '../helpers/constants.dart';
import '../utils/authorzation.dart';
import 'base_provider.dart';
import 'package:http/http.dart' as http;

class ReccuringShowProvider extends BaseProvider<ReccuringShow> {
  ReccuringShowProvider() : super('ReccuringShow/GetPaged');

  @override
  Future<ReccuringShow> insert(dynamic resource) async {
    var uri = Uri.parse('$apiUrl/ReccuringShow');
    Map<String, String> headers = Authorization.createHeaders();

    var jsonRequest = jsonEncode(resource);
    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return fromJson(data);
    } else {
      throw Exception('Greška prilikom unosa');
    }
  }

  Future<ReccuringShow> edit(dynamic resource) async {
    var uri = Uri.parse('$apiUrl/ReccuringShow');
    Map<String, String> headers = Authorization.createHeaders();

    var jsonRequest = jsonEncode(resource);
    var response = await http.put(uri, headers: headers, body: jsonRequest);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return fromJson(data);
    } else {
      throw Exception('Greška prilikom unosa');
    }
  }

  @override
  ReccuringShow fromJson(data) {
    return ReccuringShow.fromJson(data);
  }
}
