import 'package:flutter/material.dart';
import '../screens/Home.dart';
import 'package:http/http.dart' as http;
import '../widgets/bottom_nav_bar.dart';
import 'dart:convert';
import '../widgets/custom_search_bar.dart';

var primaryColor = Color.fromARGB(255, 255, 255, 255);
var secondaryColor = Color(0xFF3882cd);
var borderColor = Color.fromARGB(255, 202, 202, 202);

class SearchStoresPage extends StatefulWidget {
  @override
  _SearchStoresPageState createState() => _SearchStoresPageState();
}

class _SearchStoresPageState extends State<SearchStoresPage> {
  int _currentIndex = 1;
  List stores = [];
  int _selectedButton = 0; // Variable to track selected button
  String _searchQuery = ''; // Variable to track search query

  @override
  void initState() {
    super.initState();
    _fetchStores();
  }

  void _fetchStores({int? limit}) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:3000/stores${limit != null ? '?limit=$limit' : ''}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          stores = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load stores');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _onTap(int index) {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Stores'),
        leading: null,
      ),
      body: Column(
        children: [
          CustomSearchBar(
            hintText: 'Search stores...',
            onChanged: (query) {
              setState(() {
                _searchQuery = query;
                // You may want to filter the stores based on the search query
                // For now, it will not trigger a fetch on every change
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _selectedButton =
                        1; // Mark 'View Nearby Stores' as selected
                    _fetchStores(limit: 5);
                  });
                },
                child: Text('View Nearby Stores'),
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      _selectedButton == 1 ? secondaryColor : primaryColor,
                  foregroundColor:
                      _selectedButton == 1 ? Colors.white : Colors.black,
                  side: BorderSide(
                    color:
                        _selectedButton == 1 ? Colors.transparent : borderColor,
                    width: 2.0,
                  ),
                ),
              ),
              SizedBox(width: 10),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _selectedButton = 2; // Mark 'View All Stores' as selected
                    _fetchStores();
                  });
                },
                child: Text('View All Stores'),
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      _selectedButton == 2 ? secondaryColor : primaryColor,
                  foregroundColor:
                      _selectedButton == 2 ? Colors.white : Colors.black,
                  side: BorderSide(
                    color:
                        _selectedButton == 2 ? Colors.transparent : borderColor,
                    width: 2.0,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: stores.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(stores[index]['name']),
                    subtitle: Text(stores[index]['location']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _onTap(index);
        },
      ),
    );
  }
}
