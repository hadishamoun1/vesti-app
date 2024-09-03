import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'Home.dart';
import 'AiSearch.dart';
import 'SearchStores.dart';

class DashedDivider extends StatelessWidget {
  final double dashWidth;
  final double dashHeight;
  final double dashSpacing;
  final Color color;

  DashedDivider({
    this.dashWidth = 10.0,
    this.dashHeight = 2.0,
    this.dashSpacing = 4.0,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        (MediaQuery.of(context).size.width / (dashWidth + dashSpacing)).floor(),
        (index) => Container(
          width: dashWidth,
          height: dashHeight,
          color: color,
          margin: EdgeInsets.symmetric(horizontal: dashSpacing / 2),
        ),
      ),
    );
  }
}

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
      body: Column(
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
                Spacer(flex: 5,), // Pushes the dashed divider to the bottom
                DashedDivider(), // Add the custom dashed divider here
              ],
            ),
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
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTapped,
      ),
    );
  }
}
