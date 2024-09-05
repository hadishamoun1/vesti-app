import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String message;

  NotificationCard({
    required this.imageUrl,
    required this.name,
    required this.message,


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: ListTile(
        contentPadding: EdgeInsets.all(8),
        leading: ClipOval(
          child: Image.network(
            imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  }

  });
}
