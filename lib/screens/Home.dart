import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> stores = [];
  bool isLoading = true;
  String errorMessage = '';
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchStores();
  }

  Future<void> fetchStores() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/stores'));

      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        print(decodedResponse);

        setState(() {
          stores = decodedResponse;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load stores. Please try again later.';
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'An error occurred: $error';
        isLoading = false;
      });
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.settings),
          iconSize: 30,
          onPressed: () {
            // Handle settings button press
            print('Settings pressed');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            iconSize: 30,
            onPressed: () {
              // Handle cart button press
              print('Cart pressed');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search for stores',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Expanded(
            child: Center(child: CircularProgressIndicator()), // Placeholder
          ),
        ],
      ),
    );
  }
}



