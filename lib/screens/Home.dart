import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';




class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> stores = [];

  @override
  void initState() {
    super.initState();
    fetchStores();
  }

  Future<void> fetchStores() async {
    final response = await http.get(Uri.parse('https://your-backend-url.com/stores'));
    if (response.statusCode == 200) {
      setState(() {
        stores = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load stores');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Stores'),
      ),
      body: ListView.builder(
        itemCount: stores.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(stores[index]['name']),
            subtitle: Text(stores[index]['location']),
            leading: Image.network(stores[index]['picture_url']),
            onTap: () {
             
            },
          );
        },
      ),
    );
  }
}