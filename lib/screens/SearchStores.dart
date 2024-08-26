import 'package:flutter/material.dart';
import 'Home.dart';
import 'package:http/http.dart' as http;
import '../widgets/bottom_nav_bar.dart';
import 'dart:convert';
import '../widgets/custom_search_bar.dart';
import 'package:geolocator/geolocator.dart';

var primaryColor = Color.fromARGB(255, 255, 255, 255);
var secondaryColor = Color(0xFF3882cd);
var borderColor = Color.fromARGB(255, 202, 202, 202);

class SearchStoresPage extends StatefulWidget {
  @override
  _SearchStoresPageState createState() => _SearchStoresPageState();
}

class _SearchStoresPageState extends State<SearchStoresPage> {
  int _currentIndex = 1;
  List stores = [];
  int _selectedButton = 0;
  String _searchQuery = '';
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Request location when the page is loaded
  }

  void _getCurrentLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _fetchStoresNearby(); // Fetch nearby stores after getting the location
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _fetchStoresNearby() async {
    if (_currentPosition == null) return;

    try {
      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:3000/stores/nearby?lat=${_currentPosition!.latitude}&lon=${_currentPosition!.longitude}&limit=5'),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            stores = json.decode(response.body);
          });
        }
      } else {
        throw Exception('Failed to load stores');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _fetchStores({int? limit}) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:3000/stores${limit != null ? '?limit=$limit' : ''}'),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            stores = json.decode(response.body);
          });
        }
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
      _getCurrentLocation(); // Request location when user clicks the search icon
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
        centerTitle: true,
      ),
      body: Column(
        children: [
          CustomSearchBar(
            hintText: 'Search...',
            onChanged: (query) {
              setState(() {
                _searchQuery = query;
                _fetchStores(); // Fetch stores based on the search query
              });
            },
          ),
          SizedBox(height: 10), // Add some spacing between the search bar and buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _getCurrentLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                ),
                child: Text('View Nearby Stores'),
              ),
              ElevatedButton(
                onPressed: () {
                  _fetchStores(limit: null); // Fetch all stores
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                ),
                child: Text('View All Stores'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: stores.length,
              itemBuilder: (context, index) {
                final store = stores[index];
                return ListTile(
                  title: Text(store['name']),
                  subtitle: Text(store['description']),
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
