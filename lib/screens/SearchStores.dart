import 'package:app/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'Home.dart';
import 'package:http/http.dart' as http;
import '../widgets/bottom_nav_bar.dart';
import 'dart:convert';
import '../widgets/custom_search_bar.dart';
import 'package:geolocator/geolocator.dart';

var primaryColor = Color.fromARGB(255, 255, 255, 255);
var secondaryColor = Color(0xFF3882cd);

class SearchStoresPage extends StatefulWidget {
  @override
  _SearchStoresPageState createState() => _SearchStoresPageState();
}

class _SearchStoresPageState extends State<SearchStoresPage> {
  int _currentIndex = 1;
  List _allStores = [];
  List _filteredStores = [];
  Position? _currentPosition;
  bool _showNearbyStores = true; // Track which button is selected

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      print(
          "Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}");

      _fetchStoresNearby();
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _fetchStoresNearby() async {
    if (_currentPosition == null) return;

    try {
      final latitude = _currentPosition!.latitude;
      final longitude = _currentPosition!.longitude;

      print(
          "Fetching stores nearby with Latitude: $latitude, Longitude: $longitude");

      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:3000/stores/nearby?lat=$latitude&lon=$longitude&radius=5000&limit=5'),
      );

      print("API Response Status Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _allStores = json.decode(response.body);
            _filteredStores = _allStores;
            _showNearbyStores = true; // Set button state
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
      print("Fetching all stores");

      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/stores'),
      );

      print("API Response Status Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _allStores = json.decode(response.body);
            _filteredStores = _allStores;
            _showNearbyStores = false; // Set button state
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
      _filteredStores = _allStores.where((store) {
        final storeName = store['name']?.toLowerCase() ?? '';
        return storeName.contains(query.toLowerCase());
      }).toList();
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
    backgroundColor: Colors.white, // Background color similar to Scaffold
    body: Column(
      children: [
        // AppBar replacement
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Text(
              'Search Stores',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        CustomSearchBar(
          hintText: 'Search...',
          onChanged: (query) {
            _searchStores(query);
          },
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _getCurrentLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: _showNearbyStores ? secondaryColor : primaryColor,
                foregroundColor: _showNearbyStores ? primaryColor : Colors.black,
                side: BorderSide(color: borderColor, width: 1),
              ),
              child: Text('View Nearby Stores'),
            ),
            OutlinedButton(
              onPressed: _fetchAllStores,
              style: OutlinedButton.styleFrom(
                backgroundColor: !_showNearbyStores ? secondaryColor : primaryColor,
                foregroundColor: !_showNearbyStores ? primaryColor : Colors.black,
                side: BorderSide(color: borderColor, width: 1),
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
                            Icon(Icons.error),
                      )
                    : Icon(Icons.store),
                title: Text(storeName),
                subtitle: Text(store['description'] ?? 'No description available'),
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


