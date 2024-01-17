import 'dart:convert';
import 'package:ecinema_admin/models/employee.dart';
import '../helpers/constants.dart';
import '../models/searchObject/employee_search.dart';
import '../utils/authorzation.dart';
import 'base_provider.dart';
import 'package:http/http.dart' as http;

class EmployeeProvider extends BaseProvider<Employee> {
  EmployeeProvider() : super('Employee/GetPaged');

  @override
  Future<dynamic> insert(dynamic resource) async {
    var uri = Uri.parse('$apiUrl/Employee');
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
    var uri = Uri.parse('$apiUrl/Employee');
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
    var uri = Uri.parse('$apiUrl/Employee/$id');
    Map<String, String> headers = Authorization.createHeaders();

    var response = await http.delete(uri, headers: headers);

    if (response.statusCode == 200) {
      return "OK";
    } else {
      throw Exception('Greška prilikom unosa');
    }
  }

  Future<List<Employee>> getPaged({EmployeeSearchObject? searchObject}) async {
    var uri = Uri.parse('$apiUrl/Employee/GetPaged');
    var headers = Authorization.createHeaders();
    final Map<String, String> queryParameters = {};

    if (searchObject != null) {
      if (searchObject.name != null) {
        queryParameters['name'] = searchObject.name!;
      }

      if (searchObject.gender != null) {
        queryParameters['gender'] = searchObject.gender.toString();
      }
      if (searchObject.cinemaId != null) {
        queryParameters['cinemaId'] = searchObject.cinemaId.toString();
      }
      if (searchObject.isActive != null) {
        queryParameters['isActive'] = searchObject.isActive.toString();
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
      return items.map((d) => fromJson(d)).cast<Employee>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> insertEmployee(Map<String, dynamic> userData) async {
    try {
      var uri = Uri.parse('$apiUrl/Employee/insertEmployee');
      var request = http.MultipartRequest('POST', uri);

      var stringUserData =
          userData.map((key, value) => MapEntry(key, value.toString()));

      request.fields.addAll(stringUserData);

      if (userData.containsKey('ProfilePhoto')) {
        request.files.add(userData['ProfilePhoto']);
      }

      var response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        return "OK";
      } else {
        throw Exception('Error inserting user: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error inserting user: $e');
    }
  }

  Future<dynamic> updateEmployee(Map<String, dynamic> updatedUserData) async {
    try {
      var uri = Uri.parse('$apiUrl/Employee/updateEmployee');

      var request = http.MultipartRequest('PUT', uri);

      var stringUpdatedUserData =
          updatedUserData.map((key, value) => MapEntry(key, value.toString()));

      request.fields.addAll(stringUpdatedUserData);

      if (updatedUserData.containsKey('ProfilePhoto')) {
        request.files.add(updatedUserData['ProfilePhoto']);
      }

      var response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        return "OK";
      } else {
        throw Exception('Error updating user: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }

  @override
  Employee fromJson(data) {
    return Employee.fromJson(data);
  }
}
