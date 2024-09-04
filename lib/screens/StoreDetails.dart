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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(store['pictureUrl']),
            SizedBox(height: 20),
            Text(
              store['name'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            // Add more store details here
          ],
        ),
      ),
    );
  }
}