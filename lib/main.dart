import 'package:flutter/material.dart';
import 'screens/Home.dart';
import 'screens/Login.dart';
import 'screens/Signup.dart';

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
      home: LoginPage(),
    );
  }
}
