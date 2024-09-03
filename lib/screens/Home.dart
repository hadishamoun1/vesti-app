import 'package:app/screens/HomeTab.dart';
import 'package:flutter/material.dart';

import '../screens/SearchStores.dart';
import '../widgets/bottom_nav_bar.dart';
import 'Cart.dart';
import 'AiSearch.dart';
import 'Profile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget buildContent() {
    switch (_currentIndex) {
      case 0:
        print("object");
        return Hometab();
      case 1:
        return SearchStoresPage();
      case 2:
        return SearchScreen();
      case 3:
        return ProfilePage();

      default:
        return Hometab();
    }
  }

// Mediauery.of(context).size.height
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.settings),
          iconSize: 30,
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            iconSize: 30,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
        ],
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
      ),
      body: buildContent(),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _onTap(index);
        },
      ),
    );
  }
}
