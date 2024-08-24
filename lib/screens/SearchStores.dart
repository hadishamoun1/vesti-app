import 'package:flutter/material.dart';
import 'Home.dart';
import 'package:http/http.dart' as http; // Add http package for API calls
import 'dart:convert'; // Add dart:convert for JSON decoding

var primaryColor = Color.fromARGB(255, 253, 202, 63);
var secondaryColor = Color(0xFF174793);

class SearchStoresPage extends StatefulWidget {
  @override
  _SearchStoresPageState createState() => _SearchStoresPageState();
}

class _SearchStoresPageState extends State<SearchStoresPage> {
  int _currentIndex = 1; // Set to 1 since this is the Search Page
  List stores = []; // List to hold fetched stores data

  @override
  void initState() {
    super.initState();
    _fetchStores(); // Fetch stores when the page loads
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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchStoresPage()),
      );
    } else if (index == 0) {
      Navigator.push(
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
              onChanged: (value) {
                // Optionally, handle search input change
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Fetch nearby stores
                  _fetchStores(limit: 5); // Example limit for nearby stores
                },
                child: Text('View Nearby Stores'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor), // Updated here
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  // Fetch all stores
                  _fetchStores(); // No limit for all stores
                },
                child: Text('View All Stores'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor), // Updated here
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
                    // Add more store details here if needed
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: secondaryColor,
          currentIndex: _currentIndex,
          iconSize: 40,
          onTap: _onTap,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
