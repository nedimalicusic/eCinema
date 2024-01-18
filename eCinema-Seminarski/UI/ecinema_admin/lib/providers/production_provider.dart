import 'dart:convert';
import 'package:ecinema_admin/models/production.dart';
import 'package:http/http.dart' as http;
import '../helpers/constants.dart';
import '../models/searchObject/production_search.dart';
import '../utils/authorzation.dart';
import 'base_provider.dart';

class ProductionProvider extends BaseProvider<Production> {
  ProductionProvider() : super('Production/GetPaged');

  @override
  Future<dynamic> insert(dynamic resource) async {
    var uri = Uri.parse('$apiUrl/Production');
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
    var uri = Uri.parse('$apiUrl/Production');
    Map<String, String> headers = Authorization.createHeaders();

    var jsonRequest = jsonEncode(resource);
    var response = await http.put(uri, headers: headers, body: jsonRequest);

    if (response.statusCode == 200) {
      return "OK";
    } else {
      throw Exception('Greška prilikom unosa');
    }
  }

  Future<List<Production>> getPaged(
      {ProductionSearchObject? searchObject}) async {
    var uri = Uri.parse('$apiUrl/Production/GetPaged');
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
      return items.map((d) => fromJson(d)).cast<Production>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> delete(int id) async {
    var uri = Uri.parse('$apiUrl/Production/$id');
    Map<String, String> headers = Authorization.createHeaders();

    var response = await http.delete(uri, headers: headers);

    if (response.statusCode == 200) {
      return "OK";
    } else {
      throw Exception('Greška prilikom unosa');
    }
  }

  @override
  Production fromJson(data) {
    return Production.fromJson(data);
  }
}
