import 'dart:convert';
import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../helpers/constants.dart';
import '../utils/authorization.dart';


abstract class BaseProvider<T> with ChangeNotifier {
  String endpoint;
  BaseProvider(this.endpoint);

  Future<List<T>> get(Map<String, String>? params) async {
    var uri = Uri.parse('$apiUrl/$endpoint');
    var headers = Authorization.createHeaders();
    if (params != null) {
      uri = uri.replace(queryParameters: params);
    }
    print(uri);
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var items=data['items'];
      return items.map((d) => fromJson(d)).cast<T>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<T> getById(int id) async {
    var uri = Uri.parse('$apiUrl/$endpoint/$id');
    var headers = Authorization.createHeaders();
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return fromJson(data);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> insert(dynamic resource) async {
    var uri = Uri.parse('$apiUrl/$endpoint');
    Map<String, String> headers = Authorization.createHeaders();

    var jsonRequest = jsonEncode(resource);
    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data is List) {
        return data.map((d) => fromJson(d)).cast<T>().toList();
      }

      return fromJson(data);
    } else {
      throw Exception('Greška prilikom unosa');
    }
  }

  T fromJson(data) {
    throw Exception("Override method");
  }
}