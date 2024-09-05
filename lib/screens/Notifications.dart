import 'package:flutter/material.dart';

import '../widgets/NotificationCard.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // This list will store the static notifications data
  final List<NotificationItem> _notifications = [
    NotificationItem(
      imageUrl: 'https://via.placeholder.com/50',
      name: 'Store Name',
      message: 'This is a sample notification message from the store.',
    ),
    NotificationItem(
      imageUrl: 'https://via.placeholder.com/50',
      name: 'Another Store',
      message: 'Another sample notification message from another store.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
        body: ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return NotificationCard(
            imageUrl: notification.imageUrl,
            name: notification.name,
            message: notification.message,
          );
        },
        ),
    );
  }
}
