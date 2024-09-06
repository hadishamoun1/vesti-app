import 'package:geolocator/geolocator.dart';

// One-time location fetch
Future<Position> getUserLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Geolocator.openLocationSettings();
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}

// Continuous location updates
Stream<Position> getLocationUpdates() {
  return Geolocator.getPositionStream(
    locationSettings: LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Get updates after moving 10 meters
    ),
  );
}

void listenToLocationUpdates() {
  Stream<Position> positionStream = getLocationUpdates();

  positionStream.listen((Position position) {
    print('Updated User Location: ${position.latitude}, ${position.longitude}');
    
  });
}
