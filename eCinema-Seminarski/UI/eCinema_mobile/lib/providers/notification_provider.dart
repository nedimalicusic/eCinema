import 'dart:convert';
import 'package:ecinema_mobile/models/notifications.dart';
import '../helpers/constants.dart';
import '../utils/authorization.dart';
import 'base_provider.dart';
import 'package:http/http.dart' as http;

class NotificationProvider extends BaseProvider<Notifications> {
  NotificationProvider() : super('Notification/GetPaged');

  List<Notifications> _notifications = [];

  List<Notifications> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => !n.seen).length;

  Future<void> loadByUserId(int userId) async {
    _notifications = await getByUserId(userId);
    notifyListeners();
  }

  Future<Notifications> create(Notifications notification) async {
    var uri = Uri.parse('$apiUrl/Notification');
    var headers = Authorization.createHeaders();
    headers['Content-Type'] = 'application/json';

    final response = await http.post(
      uri,
      headers: headers,
      body: json.encode({
        'Title': notification.title,
        'Description': notification.description,
        'SendOnDate': notification.sendOnDate.toIso8601String(),
        'DateRead': notification.dateRead?.toIso8601String(),
        'Seen': notification.seen,
        'UserId': notification.userId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final createdNotification = fromJson(json.decode(response.body));
      _notifications.add(createdNotification);
      notifyListeners();
      return createdNotification;
    } else {
      throw Exception('Failed to create notification');
    }
  }

  Future<void> markAsRead(int id) async {
    var uri = Uri.parse('$apiUrl/Notification/MarkAsRead?notificationId=$id');

    var headers = Authorization.createHeaders();
    headers['Content-Type'] = 'application/json';

    final response = await http.put(uri, headers: headers);

    if (response.statusCode == 200) {
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index].seen = true;
        _notifications[index].dateRead = DateTime.now();
        notifyListeners();
      }
    } else {
      throw Exception('Failed to mark notification as read');
    }
  }

  Future<List<Notifications>> getByUserId(int id) async {
    var uri = Uri.parse('$apiUrl/Notification/GetByUserId?userId=$id');
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
