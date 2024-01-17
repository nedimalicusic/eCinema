import 'dart:convert';
import 'package:ecinema_admin/models/loginUser.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import '../helpers/constants.dart';
import '../utils/authorzation.dart';
import 'base_provider.dart';

class LoginProvider extends BaseProvider<LoginUser> {
  LoginProvider() : super('User/GetPaged');
  LoginUser? loginUser;

  refreshUser() async {
    loginUser = await getById(int.parse(loginUser!.Id));
  }

  @override
  Future<LoginUser> getById(int id) async {
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

  Future<LoginUser> loginAsync(String email, String password) async {
    var url = '$apiUrl/Access/SignIn';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(response.body);
      loginUser = LoginUser.fromJson(decodedToken);
      Authorization.token = loginUser!.token;
      notifyListeners();
      return loginUser!;
    } else {
      throw Exception(response.body);
    }
  }

  void logout() {
    loginUser = null;
    notifyListeners();
  }

  @override
  fromJson(data) {
    return LoginUser.fromJson(data);
  }
}
