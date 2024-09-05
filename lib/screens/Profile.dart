import 'dart:convert'; // For converting API response
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/widgets/DashedDivider.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import 'Notifications.dart';

var secondaryColor = Color(0xFF3882cd);

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = '';
  String userEmail = '';
 int userId=0;

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
        Uri.parse('http://10.0.2.2:3000/users/$userId'),
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
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: Image.network(
                          'https://th.bing.com/th/id/R.fd51499e37b3340832ac271d2fee4a80?rik=MqY4rciAudYrwA&pid=ImgRaw&r=0',
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text(
                            userName.isNotEmpty ? userName : 'Loading...',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
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
                    ],
                  ),
                ],
              ),
            ),
            DashedDivider(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.notifications, color: secondaryColor),
                    title: Text('Notifications'),
                     trailing: Icon(Icons.arrow_forward_ios, size: 16, color: secondaryColor),
                    onTap: () {
                       Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationsPage(userId: userId),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.favorite, color: Colors.red),
                    title: Text('Favorites'),
                     trailing: Icon(Icons.arrow_forward_ios, size: 16, color: secondaryColor),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.list, color: secondaryColor),
                    title: Text('Orders'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: secondaryColor),
                    onTap: () {},
                  ),
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
    );
  }
}
