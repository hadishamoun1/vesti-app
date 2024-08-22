import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> stores = [];
  List<dynamic> productsByCategory = [];
  bool isLoading = true;
  String errorMessage = '';
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<String> categories = ["Shoes", "Electronics", "Clothing", "Furniture"];
  Map<int, bool> favoriteStatus = {};
  String selectedCategory = "Shoes";
  int _currentIndex = 0;
  var primarry_color = Color.fromARGB(255, 253, 202, 63);
  var secondary_color = Color.fromRGBO(15, 160, 173, 1);

  // WebSocket channel
  late WebSocketChannel _channel;

  @override
  void initState() {
    super.initState();
    fetchStores();
    fetchProductsByCategory(selectedCategory);
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://10.0.2.2:3000'),
    );
    _channel.stream.listen(
      (message) {
        final newStore = json.decode(message);
        setState(() {
          stores.add(newStore);
          favoriteStatus[stores.length - 1] = false;
        });
      },
      onError: (error) {
        setState(() {
          errorMessage = 'WebSocket error occurred.';
        });
      },
      onDone: () {
        setState(() {
          errorMessage = 'WebSocket connection closed.';
        });
      },
    );
  }

  Future<void> fetchStores() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:3000/stores?limit=2'));

      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);

        setState(() {
          stores = decodedResponse;
          isLoading = false;
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

  Future<void> fetchProductsByCategory(String category) async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:3000/products/category/$category'));

      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);

        setState(() {
          productsByCategory = decodedResponse;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load products. Please try again later.';
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'An error occurred: $error';
      });
    }
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
      // Handle navigation or other logic based on the selected index
    });
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

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
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
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
                    hintText: 'Search for ${selectedCategory}',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[500],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[250]),
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
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: categories.map((category) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                        fetchProductsByCategory(selectedCategory);
                      });
                    },
                    child: Chip(
                      label: Text(
                        category,
                        style: TextStyle(
                          color: selectedCategory == category
                              ? Colors.white // Text color when selected
                              : Colors.black, // Text color when not selected
                        ),
                      ),
                      backgroundColor: selectedCategory == category
                          ? secondary_color
                          : primarry_color,
                      side: BorderSide(
                        color: selectedCategory == category
                            ? secondary_color // Border color when selected
                            : primarry_color, // Border color when not selected
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 15, 16, 5),
              child: Text(
                'Trending stores',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11.0),
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : errorMessage.isNotEmpty
                      ? Center(child: Text(errorMessage))
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 1.0,
                          ),
                          itemCount: stores.length,
                          itemBuilder: (context, index) {
                            final store = stores[index];
                            final location =
                                store['location']?['coordinates'] ?? [];
                            final imageUrl = store['pictureUrl'] ?? '';

                            if (_searchQuery.isNotEmpty &&
                                !store['name']
                                    ?.toLowerCase()
                                    .contains(_searchQuery.toLowerCase())) {
                              return Container();
                            }

                            final isFavorite = favoriteStatus[index] ?? false;

                            return Card(
                              elevation: 5,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
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
                                        store['name'] ??
                                            'Unknown Store', // Handle null store name
                                        style: TextStyle(fontSize: 15),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 1.0),
                                    child: Text(
                                      'Location: Lat ${location.isNotEmpty ? location[1] : 'N/A'}, Long ${location.isNotEmpty ? location[0] : 'N/A'}',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 15, 16, 5),
              child: Text(
                'Latest $selectedCategory',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11.0),
              child: productsByCategory.isEmpty
                  ? Center(child: Text('No products available'))
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: productsByCategory.length,
                      itemBuilder: (context, index) {
                        final product = productsByCategory[index];
                        final imageUrl = product['imageUrl'] ?? '';

                        return Card(
                          elevation: 5,
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
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
                                        return Icon(Icons.error, size: 100);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 1.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    product['name'] ??
                                        'Unknown Product', // Handle null product name
                                    style: TextStyle(fontSize: 15),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 1.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    product['price'] ??
                                        'Unknown price', // Handle null product price
                                    style: TextStyle(fontSize: 15),
                                    textAlign: TextAlign.left,
                                  ),
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
          backgroundColor: secondary_color,
          currentIndex: _currentIndex,
          iconSize: 40,
          onTap: _onTap,
          selectedItemColor: primarry_color,
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
