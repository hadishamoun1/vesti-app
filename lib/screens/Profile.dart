import 'package:flutter/material.dart';
import 'package:app/widgets/DashedDivider.dart'; // Import the DashedDivider widget
import '../widgets/bottom_nav_bar.dart';
import 'Home.dart';
import 'AiSearch.dart';
import 'SearchStores.dart';

var secondaryColor = Color(0xFF3882cd);

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 3;

  void _onBottomNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SearchStoresPage()),
      );
    } else if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SearchScreen()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
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
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text(
                            'John Doe',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'john.doe@example.com',
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
                    width: MediaQuery.of(context).size.width, // Ensure full width
                    alignment: Alignment.bottomCenter,
                  ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.notifications, color: secondaryColor),
                    title: Text('Notifications'),
                    onTap: () {
                      //Navigator.push(
                      //context,
                      // MaterialPageRoute(builder: (context) => NotificationsPage()),
                      //);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.favorite, color: Colors.red),
                    title: Text('Favorites'),
                    onTap: () {
                      //Navigator.push(
                      //context,
                      //MaterialPageRoute(builder: (context) => FavoritesPage()),
                      //);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.list, color: secondaryColor),
                    title: Text('Orders'),
                    onTap: () {
                      //Navigator.push(
                      //context,
                      //MaterialPageRoute(builder: (context) => OrdersPage()),
                      //);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTapped,
      ),
    );
  }
}
