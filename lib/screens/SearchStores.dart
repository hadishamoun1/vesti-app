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
  List _allStores = [];
  List _filteredStores = [];
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

      // Debugging: Log the obtained latitude and longitude
      print(
          "Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}");

      _fetchStoresNearby(); // Fetch nearby stores after getting the location
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _fetchStoresNearby() async {
    if (_currentPosition == null) return;

    try {
      final latitude = _currentPosition!.latitude;
      final longitude = _currentPosition!.longitude;

      // Debugging: Print the latitude and longitude before making the request
      print(
          "Fetching stores nearby with Latitude: $latitude, Longitude: $longitude");

      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:3000/stores/nearby?lat=$latitude&lon=$longitude&radius=5000&limit=5'),
      );

      // Print the raw response from the API
      print("API Response Status Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _allStores = json.decode(response.body);
            _filteredStores = _allStores;
          });
        }
      } else {
        throw Exception('Failed to load stores');
      }
    } catch (e) {
      print("Error fetching nearby stores: ${e.toString()}");
    }
  }

  void _fetchAllStores() async {
    try {
      // Debugging: Log the URL before making the request
      print("Fetching all stores");

      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/stores'),
      );

      // Print the raw response from the API
      print("API Response Status Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _allStores = json.decode(response.body);
            _filteredStores = _allStores;
          });
        }
      } else {
        throw Exception('Failed to load stores');
      }
    } catch (e) {
      print("Error fetching stores: ${e.toString()}");
    }
  }

  void _searchStores(String query) {
    setState(() {
      _filteredStores = _allStores
          .where((store) {
            final storeName = store['name']?.toLowerCase() ?? '';
            return storeName.contains(query.toLowerCase());
          })
          .toList();
    });
  }

  void _onTap(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            switch (index) {
              case 0:
                return HomePage();
              case 1:
                return SearchStoresPage();
              default:
                return SearchStoresPage();
            }
          },
        ),
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
              _searchStores(query); // Search through the displayed data
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
                onPressed: _fetchAllStores, // Fetch all stores
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                ),
                child: Text('View All Stores'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredStores.length,
              itemBuilder: (context, index) {
                final store = _filteredStores[index];

                // Ensure store is not null and provide default values if necessary
                final storeName = store['name'] ?? 'Unnamed Store';
                final pictureURL = store['pictureURL'];

                return ListTile(
                  leading: pictureURL != null && pictureURL.isNotEmpty
                      ? Image.network(
                          pictureURL,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.error), // Placeholder for error
                        )
                      : Icon(
                          Icons.store), // Default icon if no image is available
                  title: Text(storeName),
                  subtitle:
                      Text(store['description'] ?? 'No description available'),
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
