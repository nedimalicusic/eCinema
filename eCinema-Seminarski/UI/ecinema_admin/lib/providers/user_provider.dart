import 'package:http/http.dart' as http;
import 'dart:convert';
import '../helpers/constants.dart';
import '../models/searchObject/user_search.dart';
import '../models/user.dart';
import '../models/user_for_selection.dart';
import '../utils/authorzation.dart';
import 'base_provider.dart';

class UserProvider extends BaseProvider<User> {
  UserProvider() : super('User/GetPaged');
  User? user;

  @override
  Future<List<User>> get(Map<String, String>? params) async {
    var uri = Uri.parse('$apiUrl/User/GetPaged');
    var headers = Authorization.createHeaders();
    if (params != null) {
      uri = uri.replace(queryParameters: {'name': params.values});
    }
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var items = data['items'];
      return items.map((d) => fromJson(d)).cast<User>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Future<dynamic> insert(dynamic resource) async {
    var uri = Uri.parse('$apiUrl/User');
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
    var uri = Uri.parse('$apiUrl/User');
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
    var uri = Uri.parse('$apiUrl/User/$id');
    Map<String, String> headers = Authorization.createHeaders();

    var response = await http.delete(uri, headers: headers);

    if (response.statusCode == 200) {
      return "OK";
    } else {
      throw Exception('Greška prilikom unosa');
    }
  }

  @override
  Future<User> getById(int id) async {
    var uri = Uri.parse('$apiUrl/User/$id');

    var headers = Authorization.createHeaders();

    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      return fromJson(data);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> insertUser(Map<String, dynamic> userData) async {
    try {
      var uri = Uri.parse('$apiUrl/User');

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

  Future<List<User>> getPaged({UserSearchObject? searchObject}) async {
    var uri = Uri.parse('$apiUrl/User/GetPaged');
    var headers = Authorization.createHeaders();
    final Map<String, String> queryParameters = {};

    if (searchObject != null) {
      if (searchObject.name != null) {
        queryParameters['name'] = searchObject.name!;
      }

      if (searchObject.gender != null) {
        queryParameters['gender'] = searchObject.gender.toString();
      }

      if (searchObject.role != null) {
        queryParameters['role'] = searchObject.role.toString();
      }

      if (searchObject.isActive != null) {
        queryParameters['isActive'] = searchObject.isActive.toString();
      }
      if (searchObject.isVerified != null) {
        queryParameters['isVerified'] = searchObject.isVerified.toString();
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
      return items.map((d) => fromJson(d)).cast<User>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> updateUser(Map<String, dynamic> updatedUserData) async {
    try {
      var uri = Uri.parse('$apiUrl/User');

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

  Future<List<UserForSelection>> getusersForSelection(
      {UserSearchObject? searchObject}) async {
    var uri = Uri.parse('$apiUrl/User/GetUsersForSelection');
    var headers = Authorization.createHeaders();

    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data is List) {
        return data.map((d) => UserForSelection.fromJson(d)).toList();
      } else {
        throw Exception('Invalid data format');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  fromJson(data) {
    return User.fromJson(data);
  }
}
