import 'package:ecinema_mobile/models/notifications.dart';
import 'package:ecinema_mobile/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/notification_provider.dart';
import '../utils/error_dialog.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationProvider _notificationProvider;
  late UserLoginProvider userProvider;
  List<Notifications> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _notificationProvider = context.read<NotificationProvider>();
    userProvider = context.read<UserLoginProvider>();
    loadNotifications();
  }

  Future loadNotifications() async {
    try {
      var data = await _notificationProvider.getByUserId(int.parse(userProvider.user!.id));
      setState(() {
        notifications = data;
        isLoading = false;
      });
    } on Exception catch (e) {
      isLoading = false;
      showErrorDialog(context, e.toString().substring(11));
    }
  }

  Future markNotificationAsSeen(Notifications notification) async {
    if (!notification.seen) {
      try {
        await _notificationProvider.markAsRead(notification.id!);
        setState(() {
          notification.seen = true;
        });
      } on Exception catch (e) {
        showErrorDialog(context, "Greška prilikom označavanja notifikacije kao pročitane: ${e.toString().substring(11)}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifikacije"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            )
          : notifications.isEmpty
              ? const Center(
                  child: Text(
                    "Nemate notifikacija.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.teal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return GestureDetector(
                      onTap: () => markNotificationAsSeen(notification),
                      child: _buildNotification(notification),
                    );
                  },
                ),
    );
  }

  Widget _buildNotification(Notifications notification) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.teal, width: 1.0),
        borderRadius: BorderRadius.circular(16),
        color: notification.seen ? Colors.white : Colors.teal[300],
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Icon(
              Icons.notifications,
              color: notification.seen ? Colors.teal : Colors.white,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: notification.seen ? Colors.teal : Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  notification.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: notification.seen ? Colors.teal : Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Datum: ${notification.sendOnDate.toLocal().toString().substring(0, 16)}",
                  style: TextStyle(
                    fontSize: 10,
                    color: notification.seen ? Colors.teal : Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
