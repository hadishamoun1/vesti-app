import 'dart:convert';

import 'package:app/widgets/category_chips.dart';
import 'package:app/widgets/custom_search_bar.dart';
import 'package:app/widgets/product_grid.dart';
import 'package:app/widgets/store_grid.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

class Hometab extends StatefulWidget {
  const Hometab({super.key});

  @override
  State<Hometab> createState() => _HometabState();
}

class _HometabState extends State<Hometab> {
  // WebSocket channel
  late WebSocketChannel _channel;

  List<dynamic> stores = [];
  List<dynamic> productsByCategory = [];
  bool isLoading = true;
  String errorMessage = '';
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String selectedCategory = "Shoes";

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
        if (mounted) {
          setState(() {
            stores.add(newStore);
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            errorMessage = 'WebSocket error occurred.';
          });
        }
      },
      onDone: () {
        if (mounted) {
          setState(() {
            errorMessage = 'WebSocket connection closed.';
          });
        }
      },
    );
  }

  Future<void> fetchStores() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:3000/stores?limit=2'));

      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        if (mounted) {
          setState(() {
            stores = decodedResponse;
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            errorMessage = 'Failed to load stores. Please try again later.';
            isLoading = false;
          });
        }
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          errorMessage = 'An error occurred: $error';
          isLoading = false;
        });
      }
    }
  }

  Future<void> fetchProductsByCategory(String category) async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2:3000/products/category/$category'));

      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = json.decode(response.body);
        if (mounted) {
          setState(() {
            productsByCategory = decodedResponse;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            errorMessage = 'Failed to load products. Please try again later.';
          });
        }
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          errorMessage = 'An error occurred: $error';
        });
      }
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
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
    );
  }
}
