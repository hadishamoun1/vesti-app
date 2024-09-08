import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class OpenStreetMapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OpenStreetMap'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(33.8886, 35.4955),
          initialZoom: 13.0,
          onTap: (tapPosition, point) {
            print('Tapped position: $point');
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
            // Attribution text can be added here directly
            // FlutterMap should handle the attribution automatically
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(33.8886, 35.4955),
                width: 80.0,
                height: 80.0,
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
    );
  }
}
