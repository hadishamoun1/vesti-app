import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:app/widgets/category_chips.dart';
import 'package:app/widgets/custom_search_bar.dart';
import 'package:app/widgets/product_grid.dart';
import 'package:app/widgets/store_grid.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Hometab extends StatefulWidget {
  const Hometab({super.key});

  @override
  State<Hometab> createState() => _HometabState();
}

class _HometabState extends State<Hometab> {
  // WebSocket channel
  late WebSocketChannel _channel;

  // Location tracking
  bool _isLocationServiceInitialized = false;

  List<dynamic> stores = [];
  List<dynamic> productsByCategory = [];
  bool isLoading = true;
  String errorMessage = '';
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String selectedCategory = "Shoes";
  final apiUrl = dotenv.env['API_URL'];
  final wsUrl = dotenv.env['WS_URL'];

  @override
  void initState() {
    super.initState();
    fetchStores();
    fetchProductsByCategory(selectedCategory.toLowerCase());
    _initializeWebSocket();
    _initializeBackgroundGeolocation();
  }

  void _initializeWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse('$wsUrl?limit=2'),
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

  Future<void> _initializeBackgroundGeolocation() async {
    try {
      final bg.State state = await bg.BackgroundGeolocation.state;
      if (!state.enabled) {
        await bg.BackgroundGeolocation.start();
      }
      _isLocationServiceInitialized = true;

      Timer.periodic(Duration(minutes: 10), (timer) async {
        try {
          final location = await bg.BackgroundGeolocation.getCurrentPosition();
          print('Current Location: ${location.coords}');

          final response = await http.get(
            Uri.parse(
              '$apiUrl/stores/nearby?lat=${location.coords.latitude}&lon=${location.coords.longitude}&radius=5000&limit=10',
            ),
          );

          if (response.statusCode == 200) {
            final List<dynamic> stores = json.decode(response.body);
            if (stores.isEmpty) {
              print('No nearby stores found. Retrying...');
            } else {
              _sendNotificationsForNearbyStores(stores);
              print('Nearby stores: $stores');
            }
          } else {
            print(
                'Failed to fetch nearby stores. Status code: ${response.statusCode}');
          }
        } catch (e) {
          print('Error fetching nearby stores: $e');
        }
      });
    } catch (e) {
      print('Error initializing BackgroundGeolocation: $e');
    }
  }

  void _sendNotificationsForNearbyStores(List<dynamic> stores) {
    for (var store in stores) {
      final title = store['name'];
      final body = '${store['name']} is making discounts!';

      _sendNotification(title, body);
    }
  }

  void _sendNotification(String title, String body) async {
    final url = '$apiUrl/notifications/send-notification';

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'body': body,
      }),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification');
      print('Response body: ${response.body}');
    }
  }

  Future<void> fetchStores() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/stores?limit=2'));

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
      final response =
          await http.get(Uri.parse('$apiUrl/products/category/$category'));

      print('API Response: ${response.body}');

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
    if (_isLocationServiceInitialized) {
      bg.BackgroundGeolocation.stop();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              categories: [
                "Hoodies",
                "T-Shirts",
                "Shirts",
                "Over Shirts",
              ],
              selectedCategory: selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  selectedCategory = category;
                  print(selectedCategory);
                  fetchProductsByCategory(selectedCategory.toLowerCase());
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 15, 16, 5),
              child: Text(
                'Trending stores',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            StoreGrid(
              isLoading: isLoading,
              errorMessage: errorMessage,
              stores: stores,
              searchQuery: _searchQuery,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 15, 24, 10),
              child: Text(
                'Latest $selectedCategory',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            ProductGrid(
              products: productsByCategory,
            ),
          ],
        ),
      ),
    );
  }
}
