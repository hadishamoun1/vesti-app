import 'package:flutter/material.dart';
import 'Home.dart';

var primaryColor = Color.fromARGB(255, 253, 202, 63);
var secondaryColor = Color(0xFF174793);

class SearchStoresPage extends StatefulWidget {
  @override
  _SearchStoresPageState createState() => _SearchStoresPageState();
}

class _SearchStoresPageState extends State<SearchStoresPage> {
  int _currentIndex = 1; // Set to 1 since this is the Search Page

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchStoresPage()),
      );
    } else if (index == 0) {
     
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Stores'),
      ),
      body: Center(
        child: Text('Search for stores here'),
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: secondaryColor,
          currentIndex: _currentIndex,
          iconSize: 40,
          onTap: _onTap,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
