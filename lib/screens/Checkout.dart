import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../widgets/OpenStreetMap.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  LatLng _markerPosition = LatLng(33.8938, 35.5018);

  void _onTap(LatLng point) {
    setState(() {
      _markerPosition = point;
    });
    print('Tapped position: $point');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        actions: [
          IconButton(
            icon: Icon(Icons.location_on),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OpenStreetMapScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Payment Content Here'),
      ),
    );
  }
}
