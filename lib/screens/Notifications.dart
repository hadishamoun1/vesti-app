import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/NotificationCard.dart';

class NotificationsPage extends StatefulWidget {
  final int userId;

  NotificationsPage({required this.userId});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<NotificationItem> _notifications = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

Future<void> _fetchNotifications() async {
  final String apiUrl =
      'http://10.0.2.2:3000/notifications?userId=${widget.userId}'; 

  try {
    final response = await http.get(Uri.parse(apiUrl));

    print('Response status: ${response.statusCode}'); 

    if (response.statusCode == 200) {
      final List<dynamic> notificationsData = jsonDecode(response.body);

      List<NotificationItem> notifications = [];
      for (var notification in notificationsData) {
        notifications.add(NotificationItem(
          imageUrl: notification['store']['imageUrl'] ??
              'https://via.placeholder.com/50',
          name: notification['store']['name'] ?? 'Unknown Store',
          message: notification['message'] ?? 'No message available.',
        ));
      }

      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    } else {
      print('Failed to load notifications: ${response.body}');
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  } catch (error) {
    print('Error fetching notifications: $error');
    setState(() {
      _hasError = true;
      _isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Notifications'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _hasError
              ? Center(child: Text('Failed to load notifications'))
              : ListView.builder(
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    final notification = _notifications[index];
                    return NotificationCard(
                      imageUrl: getImageUrl(notification.imageUrl),
                      name: notification.name,
                      message: notification.message,
                    );
                  },
                ),
    );
  }
  String getImageUrl(String relativePath) {
    return 'http://10.0.2.2:3000$relativePath';
  }
}

class NotificationItem {
  final String imageUrl;
  final String name;
  final String message;

  NotificationItem({
    required this.imageUrl,
    required this.name,
    required this.message,
  });
}
