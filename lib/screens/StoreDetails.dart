import 'package:flutter/material.dart';

class StoreDetailsPage extends StatelessWidget {
  final Map<String, dynamic> store;

  StoreDetailsPage({required this.store});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(store['name']),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Container(
              width: double.infinity,
              height: 250, 
              child: Image.network(
                store['pictureUrl'],
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 50,
                    ),
                  );
                },
              ),
            ),
            // Store Name
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                store['name'],
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Additional details can be added below
          ],
        ),
      ),
    );
  }
}
