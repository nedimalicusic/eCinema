
import 'dart:convert';
import 'package:ecinema_mobile/models/notifications.dart';

import '../helpers/constants.dart';
import '../utils/authorization.dart';
import 'base_provider.dart';
import 'package:http/http.dart' as http;

class NotificationProvider extends BaseProvider<Notifications> {
  NotificationProvider() : super('Notification/GetPaged');

  @override
  Future<List<Notifications>> getByUserId(int id) async {
    var uri = Uri.parse('$apiUrl/Notification/GetByUserId?userId=${id}');

    var headers = Authorization.createHeaders();

    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data.map((d) => fromJson(d)).cast<Notifications>().toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Notifications fromJson(data) {
    return Notifications.fromJson(data);
  }
}
