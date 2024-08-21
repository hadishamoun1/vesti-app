import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> stores = [];
  bool isLoading = true;
  String errorMessage = '';
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<String> categories = ["Shoes", "Electronics", "Clothing", "Furniture"];

  @override
  void initState() {
    super.initState();
    fetchStores();
  }

  Future<void> fetchStores() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/stores'));

      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        print(decodedResponse);

        setState(() {
          stores = decodedResponse;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load stores. Please try again later.';
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'An error occurred: $error';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.settings),
          iconSize: 30,
          onPressed: () {
            // Handle settings button press
            print('Settings pressed');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            iconSize: 30,
            onPressed: () {
              // Handle cart button press
              print('Cart pressed');
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search for stores',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: categories.map((category) {
                return Chip(
                  label: Text(category),
                  backgroundColor: Colors.blueGrey[100],
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                    ? Center(child: Text(errorMessage))
                    : ListView.builder(
                        itemCount: stores.length,
                        itemBuilder: (context, index) {
                          final store = stores[index];
                          final location = store['location']['coordinates'];
                          final imageUrl = store['pictureUrl'];

                          if (_searchQuery.isNotEmpty &&
                              !store['name']
                                  .toLowerCase()
                                  .contains(_searchQuery.toLowerCase())) {
                            return Container(); // Skip this item
                          }

                          return Card(
                            margin: EdgeInsets.all(8.0),
                            elevation: 5,
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16.0),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  imageUrl,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.error, size: 100);
                                  },
                                ),
                              ),
                              title: Text(
                                store['name'],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'Location: Lat ${location[1]}, Long ${location[0]}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              isThreeLine: true,
                              onTap: () {
                                // Handle store tap
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black, // Background color of the BottomNavigationBar
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(20.0)), // Border radius
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), // Shadow color
              spreadRadius: 2, // Spread radius
              blurRadius: 8, // Blur radius
              offset: Offset(0, -2), // Offset for shadow
            ),
          ],
        ),
        child: SizedBox(
          height: 80, // Height of the BottomNavigationBar
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.0)), // Border radius for clipping
            child: BottomNavigationBar(
              backgroundColor: Colors
                  .black, // Background color of the BottomNavigationBar items
              selectedItemColor: Colors.black, // Color of the selected item
              unselectedItemColor:
                  Colors.grey[600], // Color of the unselected items
              iconSize: 40, // Control the size of the icons here
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
                  icon: Icon(Icons.notifications),
                  label: 'Notifications',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: 'Profile',
                ),
              ],
              onTap: (index) {
                // Handle bottom navigation bar item taps
                print('Selected index: $index');
              },
            ),
          ),
        ),
      ),
    );
  }
}
