import 'package:flutter/material.dart';
import 'screens/Home.dart';
import 'screens/Loading.dart';
import 'screens/Login.dart';
import 'screens/Signup.dart';
import 'package:geolocator/geolocator.dart';
import 'services/location_service.dart';

void main() async {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       
       routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => HomePage(),
        
      },
      home: SplashScreen(),
    );
  }
}
void fetchLocation() async {
  try {
    Position position = await getUserLocation();
    print('User Location: ${position.latitude}, ${position.longitude}');
  } catch (e) {
    print('Error fetching location: $e');
  }
}