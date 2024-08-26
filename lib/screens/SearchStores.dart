import 'package:flutter/material.dart';
import 'Home.dart';
import 'package:http/http.dart' as http;
import '../widgets/bottom_nav_bar.dart';
import 'dart:convert';

var primaryColor = Color.fromARGB(255, 253, 202, 63);
var secondaryColor = Color(0xFF174793);

class SearchStoresPage extends StatefulWidget {
  @override
  _SearchStoresPageState createState() => _SearchStoresPageState();
}

class _SearchStoresPageState extends State<SearchStoresPage> {
  int _currentIndex = 1;
  List stores = [];

  @override
  void initState() {
    super.initState();
    _fetchStores();
  }

  void _fetchStores({int? limit}) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:3000/stores${limit != null ? '?limit=$limit' : ''}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          stores = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load stores');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });

   if (index == 1) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SearchStoresPage()),
    );
  } else if (index == 0) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Stores'),
        leading: null,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (value) {},
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _fetchStores(limit: 5);
                },
                child: Text('View Nearby Stores'),
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  _fetchStores();
                },
                child: Text('View All Stores'),
                style:
                    ElevatedButton.styleFrom(backgroundColor: secondaryColor),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: stores.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(stores[index]['name']),
                    subtitle: Text(stores[index]['location']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _onTap(index);
        },
      ),
    );
  }
}
