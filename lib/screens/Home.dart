import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import '../widgets/custom_search_bar.dart';
import '../widgets/category_chips.dart';
import '../widgets/store_grid.dart';
import '../widgets/product_grid.dart';

import '../screens/SearchStores.dart';
import '../widgets/bottom_nav_bar.dart';

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
  String selectedCategory = "Shoes";
  int _currentIndex = 0;

  // WebSocket channel
  late WebSocketChannel _channel;

  @override
  void initState() {
    super.initState();
    fetchStores();
    fetchProductsByCategory(selectedCategory);
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://10.0.2.2:3000?limit=2'),
    );
    _channel.stream.listen(
      (message) {
        final newStore = json.decode(message);
        setState(() {
          stores.add(newStore);
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
            CustomSearchBar(
              hintText: 'Search for $selectedCategory',
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
            CategoryChips(
              categories: ["Shoes", "Electronics", "Clothing", "Furniture"],
              selectedCategory: selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  selectedCategory = category;
                  fetchProductsByCategory(selectedCategory);
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 15, 16, 5),
              child: Text(
                'Trending stores',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            StoreGrid(
              isLoading: isLoading,
              errorMessage: errorMessage,
              stores: stores,
              searchQuery: _searchQuery,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 15, 16, 5),
              child: Text(
                'Latest $selectedCategory',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ProductGrid(
              products: productsByCategory,
            ),
          ],
        ),
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
