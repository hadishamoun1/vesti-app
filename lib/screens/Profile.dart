import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blueGrey[900],
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.blueGrey[700],
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage('https://via.placeholder.com/150'), 
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe', 
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'john.doe@example.com', 
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          // Navigation Section
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.notifications, color: Colors.blueGrey[700]),
                  title: Text('Notifications'),
                  onTap: () {
                    //Navigator.push(
                     // context,
                    //  MaterialPageRoute(builder: (context) => NotificationsPage()),
                   // );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.favorite, color: Colors.blueGrey[700]),
                  title: Text('Favorites'),
                  onTap: () {
                    //Navigator.push(
                      //context,
                      //MaterialPageRoute(builder: (context) => FavoritesPage()),
                    //);
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.list, color: Colors.blueGrey[700]),
                  title: Text('Orders'),
                  onTap: () {
                    //Navigator.push(
                     // context,
                     // MaterialPageRoute(builder: (context) => OrdersPage()),
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
