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

  // State to track favorite status of each store
  Map<int, bool> favoriteStatus = {};

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

          // Initialize favorite status for each store
          favoriteStatus = {for (var i = 0; i < stores.length; i++) i: false};
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
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Two cards per row
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio:
                              1.0, // Aspect ratio of 1:1 for square cards
                        ),
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

                          // Default to false if the value is null
                          final isFavorite = favoriteStatus[index] ?? false;

                          return Card(
                            margin: EdgeInsets.all(8.0),
                            elevation: 5,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: [
                                      // Square image
                                      Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(8.0)),
                                          child: Image.network(
                                            imageUrl,
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Icon(Icons.error,
                                                  size: 100);
                                            },
                                          ),
                                        ),
                                      ),
                                      // Heat icon
                                      Positioned(
                                        top: 0,
                                        right: 2,
                                        child: IconButton(
                                          icon: Icon(
                                            isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: isFavorite
                                                ? Colors.red
                                                : Colors.grey,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              favoriteStatus[index] =
                                                  !isFavorite;
                                              print(
                                                  'Favorite pressed for store: ${store['name']}');
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 1.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      store['name'],
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                      textAlign: TextAlign
                                          .left, 
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 1.0),
                                  child: Text(
                                    'Location: Lat ${location[1]}, Long ${location[0]}',
                                    style: TextStyle(color: Colors.grey[600]),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SizedBox(
          height: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
            child: BottomNavigationBar(
              backgroundColor: Colors.black,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey[600],
              iconSize: 40,
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
                print('Selected index: $index');
              },
            ),
          ),
        ),
      ),
    );
  }
}
