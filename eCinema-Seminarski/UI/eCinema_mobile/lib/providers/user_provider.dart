import 'package:ecinema_mobile/models/profile_user.dart';
import 'package:ecinema_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../helpers/constants.dart';
import '../models/user.dart';
import '../utils/authorization.dart';

class UserProvider extends BaseProvider {
  User? user;

  UserProvider() : super('User');

  refreshUser() async {
    user = await getById(user!.id);
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

  Future<ProfileUser> getProfileUserById(int id) async {
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

  Future edit(user) async {
    var uri = Uri.parse('$apiUrl/User');
    Map<String, String> headers = Authorization.createHeaders();

    var jsonRequest = jsonEncode(user);
    var response = await http.put(uri, headers: headers, body: jsonRequest);
    if (response.statusCode == 200) {
      return "OK";
    } else {
      throw Exception('Greška prilikom unosa');
    }
  }

  Future<dynamic> editUserProfile(Map<String, dynamic> updatedUserData) async {
    try {
      var uri = Uri.parse('$apiUrl/User/EditUserProfile');

      var request = http.MultipartRequest('PUT', uri);

      var stringUpdatedUserData = updatedUserData.map((key, value) => MapEntry(key, value.toString()));

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

  Future<dynamic> updateUser(Map<String, dynamic> updatedUserData) async {
    try {
      var uri = Uri.parse('$apiUrl/User');

      var request = http.MultipartRequest('PUT', uri);

      var stringUpdatedUserData = updatedUserData.map((key, value) => MapEntry(key, value.toString()));

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

  Future chanagePassword(user) async {
    var uri = Uri.parse('$apiUrl/User/ChangePassword');
    Map<String, String> headers = Authorization.createHeaders();

    var jsonRequest = jsonEncode(user);
    var response = await http.put(uri, headers: headers, body: jsonRequest);

    if (response.statusCode == 200) {
      return "OK";
    } else {
      throw Exception('Greška prilikom unosa');
    }
  }

  void logout() {
    user = null;
    notifyListeners();
  }

  @override
  fromJson(data) {
    return User.fromJson(data);
  }
}
