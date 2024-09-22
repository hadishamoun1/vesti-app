import 'dart:convert'; // For converting API response
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'Notifications.dart';
import 'OrderHistory.dart';

var secondaryColor = Color(0xFF3882cd);

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = '';
  String userEmail = '';
  int userId = 0;
  final apiUrl = dotenv.env['API_URL'];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');
    print(token);

    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      userId = decodedToken['userId'];
      print(userId);

      final response = await http.get(
        Uri.parse('$apiUrl/users/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userName = data['name'];
          userEmail = data['email'];
        });
      } else {
        print('Failed to load user data');
      }
    }
  }

  Future<void> _signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');

    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -MediaQuery.of(context).size.width * 2.5,
            left: -MediaQuery.of(context).size.width * 0.5,
            right: -MediaQuery.of(context).size.width * 0.5,
            bottom: MediaQuery.of(context).size.width * 0.4,
            child: Padding(
              padding: EdgeInsets.all(0.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 2,
                height: MediaQuery.of(context).size.width * 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xFF3882cd),
                    Color(0xFF80c8ff),
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF3882cd).withOpacity(0.5),
                      spreadRadius: 10,
                      blurRadius: 20,
                      offset: Offset(0, 0),
                    ),
                  ],
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.width * 0.3,
            left: MediaQuery.of(context).size.width * 0.37,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.account_circle,
                size: 120,
                color: secondaryColor,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * 0.5 + 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 130,
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userName.isNotEmpty ? userName : 'Loading...',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        userEmail.isNotEmpty ? userEmail : 'Loading...',
                        style: TextStyle(
                          color: Colors.black26,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        leading:
                            Icon(Icons.notifications, color: secondaryColor),
                        title: Text('Notifications'),
                        trailing: Icon(Icons.arrow_forward_ios,
                            size: 16, color: secondaryColor),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NotificationsPage(userId: userId),
                            ),
                          );
                        },
                      ),
                      Divider(),
                      ListTile(
                          leading: Icon(Icons.favorite, color: secondaryColor),
                          title: Text('Favorites'),
                          trailing: Icon(Icons.arrow_forward_ios,
                              size: 16, color: secondaryColor),
                          onTap: () {}),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.list, color: secondaryColor),
                        title: Text('Orders'),
                        trailing: Icon(Icons.arrow_forward_ios,
                            size: 16, color: secondaryColor),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderHistoryPage(),
                            ),
                          );
                        },
                      ),
                      Divider(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: FractionallySizedBox(
                      widthFactor: 0.5,
                      child: ElevatedButton(
                        onPressed: _signOut,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Sign Out',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
