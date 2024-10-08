import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String message;

  NotificationCard({
    required this.imageUrl,
    required this.name,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: ListTile(
        contentPadding: EdgeInsets.all(8),
        leading: ClipOval(
          child: Image.network(
            imageUrl,
            width: 80, 
            height: 80, 
            fit: BoxFit.fill, 
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
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
