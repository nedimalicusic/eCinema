import 'package:ecinema_mobile/models/notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/notification_provider.dart';
import '../providers/user_provider.dart';
import '../utils/error_dialog.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationProvider _notificationProvider;
  List<Notifications> notifications = <Notifications>[];
  late UserProvider userProvider;
  late User? user;

  @override
  void initState() {
    super.initState();
    _notificationProvider = context.read<NotificationProvider>();
    userProvider = context.read<UserProvider>();
    loadNotifications();
  }

  Future loadNotifications() async
  {
    try {
      var data = await _notificationProvider.getByUserId(int.parse(userProvider.user!.Id));
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
          title: Text("Notification"),
        ),
        body: Column(
        children: [
          Expanded(child: _buildNotificationsList())
    ],
    )
    );
  }

  Widget _buildNotificationsList() {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(height: 10),
            _buildNotification(context,notifications[index]),
            SizedBox(height: 5),
          ],
        );
      },
    );
  }

  Widget _buildNotification(BuildContext context,Notifications notification) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.teal, width: 1.0),
        borderRadius: BorderRadius.circular(16),
        color: Colors.teal
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // Center the icon horizontally
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(right: 16),
            child: Icon(Icons.access_alarm, color: Colors.white),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 15),
                Text(
                  notification.description,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
