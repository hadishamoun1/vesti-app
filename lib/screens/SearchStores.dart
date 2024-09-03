import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/custom_search_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

var primaryColor = Color(0xFFFFFFFF);
var secondaryColor = Color(0xFF3882cd);
var appBarColor = Colors.white;
var textColor = Colors.black;

class SearchStoresPage extends StatefulWidget {
  @override
  _SearchStoresPageState createState() => _SearchStoresPageState();
}

class _SearchStoresPageState extends State<SearchStoresPage> {
  List _allStores = [];
  List _filteredStores = [];
  Position? _currentPosition;
  bool _showNearbyStores = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      try {
        _currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        _fetchStoresNearby();
      } catch (e) {
        print("Error getting location: $e");
      }
    } else if (status.isDenied) {
      print("Location permission denied");
    } else if (status.isPermanentlyDenied) {
      // The user has permanently denied the permission, direct them to settings.
      openAppSettings();
    }
  }

  void _fetchStoresNearby() async {
    if (_currentPosition == null) return;

    try {
      final latitude = _currentPosition!.latitude;
      final longitude = _currentPosition!.longitude;

      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:3000/stores/nearby?lat=$latitude&lon=$longitude&radius=5000&limit=5'),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _allStores = json.decode(response.body);
            _filteredStores = _allStores;
            _showNearbyStores = true;
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
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/stores'),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _allStores = json.decode(response.body);
            _filteredStores = _allStores;
            _showNearbyStores = false;
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: Column(
        children: [
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
                  backgroundColor:
                      _showNearbyStores ? secondaryColor : primaryColor,
                  foregroundColor:
                      _showNearbyStores ? primaryColor : Colors.black,
                  side: BorderSide(color: secondaryColor, width: 1),
                ),
                child: Text('View Nearby Stores'),
              ),
              OutlinedButton(
                onPressed: _fetchAllStores,
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      !_showNearbyStores ? secondaryColor : primaryColor,
                  foregroundColor:
                      !_showNearbyStores ? primaryColor : Colors.black,
                  side: BorderSide(color: secondaryColor, width: 1),
                ),
                child: Text('View All Stores'),
              ),
            ],
          ),
          Expanded(
            child: _currentPosition == null
                ? Center(child: CircularProgressIndicator())
                : _filteredStores.isEmpty
                    ? Center(child: Text('No stores found'))
                    : ListView.builder(
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
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Icon(Icons.error),
                                  )
                                : Icon(Icons.store),
                            title: Text(storeName),
                            subtitle: Text(store['description'] ??
                                'No description available'),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
