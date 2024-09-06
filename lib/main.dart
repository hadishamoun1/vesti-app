import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'screens/Home.dart';
import 'screens/Loading.dart';
import 'screens/Login.dart';
import 'screens/Signup.dart';
import 'services/location_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the background service
  await FlutterBackgroundService().initialize(onStart);

  runApp(MyApp());
}

// Background service start function
void onStart(ServiceInstance service) {
  // Set up background service tasks
  service.onDataReceived.listen((event) {
    if (event?['action'] == 'start') {
      // Start listening to location updates
      listenToLocationUpdates();
    }
  });

  // Handle Android specific configurations
  if (service is AndroidServiceInstance) {
    service.setForegroundNotificationInfo(
      title: 'Location Tracking',
      content: 'Tracking location in background',
    );
  }
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
