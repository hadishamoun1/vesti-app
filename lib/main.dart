import 'package:app/models/firebase_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/Home.dart';
import 'screens/Loading.dart';
import 'screens/Login.dart';
import 'screens/Signup.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();

  subscribeToNearbyStores();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => HomePage(),
      },
      home: SplashScreen(),
    );
  }
}

FirebaseMessaging messaging = FirebaseMessaging.instance;

void subscribeToNearbyStores() {
  messaging.subscribeToTopic("nearby_stores").then((_) {
    print("Subscribed to nearby_stores topic");
  }).catchError((error) {
    print("Failed to subscribe: $error");
  });
}
