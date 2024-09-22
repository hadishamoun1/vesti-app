import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

class OpenStreetMapScreen extends StatefulWidget {
  final Function(LatLng, String) onLocationSelected;

  OpenStreetMapScreen({required this.onLocationSelected});

  @override
  _OpenStreetMapScreenState createState() => _OpenStreetMapScreenState();
}

class _OpenStreetMapScreenState extends State<OpenStreetMapScreen> {
  LatLng _markerPosition = LatLng(33.8938, 35.5018);
  final Location _location = Location();
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final locationData = await _location.getLocation();
      if (locationData.latitude != null && locationData.longitude != null) {
        setState(() {
          _markerPosition =
              LatLng(locationData.latitude!, locationData.longitude!);
        });
        _mapController.move(_markerPosition, 13.0);
        print(
            'Current location: Latitude: ${locationData.latitude}, Longitude: ${locationData.longitude}');
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _onTap(LatLng point) async {
    setState(() {
      _markerPosition = point;
    });

   
  try {
    List<geocoding.Placemark> placemarks = await geocoding.placemarkFromCoordinates(point.latitude, point.longitude);
    String streetName = placemarks.isNotEmpty
        ? placemarks.first.street ?? 'Unknown'
        : 'Unknown';

    widget.onLocationSelected(point, streetName);
    Navigator.pop(context);
  } catch (e) {
    print("Error fetching address: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OpenStreetMap'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _markerPosition,
              initialZoom: 13.0,
              onTap: (tapPosition, point) => _onTap(point),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: _markerPosition,
                    child: Container(
                      child: Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: _getCurrentLocation,
              child: Icon(Icons.my_location),
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
