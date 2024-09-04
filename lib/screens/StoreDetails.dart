import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StoreDetailsPage extends StatefulWidget {
  final int storeId;

  StoreDetailsPage({required this.storeId});

  @override
  _StoreDetailsPageState createState() => _StoreDetailsPageState();
}

class _StoreDetailsPageState extends State<StoreDetailsPage> {
  late Future<Map<String, dynamic>> store;
  late Future<List<dynamic>> products;

  @override
  void initState() {
    super.initState();
    store = fetchStore(widget.storeId);
    products = fetchProductsByStoreId(widget.storeId);
  }

  Future<Map<String, dynamic>> fetchStore(int storeId) async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3000/stores/$storeId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load store');
    }
  }

  Future<List<dynamic>> fetchProductsByStoreId(int storeId) async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:3000/products/store/$storeId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: FutureBuilder<Map<String, dynamic>>(
          future: store,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...');
            } else if (snapshot.hasError) {
              return Text('Error');
            } else {
              return Text(snapshot.data?['name'] ?? 'Store Details');
            }
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<Map<String, dynamic>>(
              future: store,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Center(child: Text('Error loading store')),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        width: double.infinity,
                        height: 250,
                        child: Image.network(
                          snapshot.data?['pictureUrl'] ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 50,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Text(
                'Products',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FutureBuilder<List<dynamic>>(
              future: products,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Center(child: Text('Error loading products')),
                  );
                } else {
                  final productList = snapshot.data ?? [];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      children: productList.map<Widget>((product) {
                        final imageUrl = product['imageUrl'] ?? '';
                        final name = product['name'] ?? 'Unknown Product';
                        final price = product['price'] ?? 0.00;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 15.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    imageUrl,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) {
                                      return Center(
                                        child: Icon(
                                          Icons.error,
                                          color: Colors.red,
                                          size: 50,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        '\$${price.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
