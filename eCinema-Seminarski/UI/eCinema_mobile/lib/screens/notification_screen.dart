import 'package:ecinema_mobile/models/notifications.dart';
import 'package:ecinema_mobile/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/loginUser.dart';
import '../providers/notification_provider.dart';
import '../utils/error_dialog.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationProvider _notificationProvider;
  List<Notifications> notifications = <Notifications>[];
  late UserLoginProvider userProvider;
  late UserLogin? user;

  @override
  void initState() {
    super.initState();
    _notificationProvider = context.read<NotificationProvider>();
    userProvider = context.read<UserLoginProvider>();
    loadNotifications();
  }

  Future loadNotifications() async {
    try {
      var data = await _notificationProvider
          .getByUserId(int.parse(userProvider.user!.Id));
      setState(() {
        notifications = data;
      });
    } on Exception catch (e) {
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Notification"),
        ),
        body: Column(
          children: [Expanded(child: _buildNotificationsList())],
        ));
  }

  Widget _buildNotificationsList() {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(height: 10),
            _buildNotification(context, notifications[index]),
            const SizedBox(height: 5),
          ],
        );
      },
    );
  }

  Widget _buildNotification(BuildContext context, Notifications notification) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.teal, width: 1.0),
          borderRadius: BorderRadius.circular(16),
          color: Colors.teal),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: const Icon(Icons.access_alarm, color: Colors.white),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 15),
                Text(
                  notification.description,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
