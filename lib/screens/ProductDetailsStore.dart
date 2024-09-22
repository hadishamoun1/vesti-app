import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductDetailsPage extends StatefulWidget {
  final dynamic product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  String? _selectedSize;
  String? _selectedColor;
  final apiUrl = dotenv.env['API_URL'];

  String getImageUrl(String relativePath) {
    
    return '$apiUrl$relativePath';
  }

  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'yellow':
        return Colors.yellow;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Future<int?> _getUserIdFromToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token != null) {
      try {
        final jwt = JWT.verify(token, SecretKey('secret7063'));

        final payload = jwt.payload;

        final userId = payload['userId'];

        return userId is int ? userId : null;
      } catch (e) {
        print('Error decoding token: $e');
        return null;
      }
    }
    return null;
  }

  void _addToCart() async {
    final userId = await _getUserIdFromToken();

    if (userId != null) {
      final response = await http.post(
        Uri.parse('$apiUrl/orders/add-to-cart'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'userId': userId,
          'storeId': widget.product['storeId'],
          'productId': widget.product['id'],
          'quantity': 1,
          'sizes': [_selectedSize],
          'colors': [_selectedColor]
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Product added to cart'),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to add product to cart'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Product Details'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          getImageUrl(widget.product['imageUrl'] ?? ''),
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(Icons.error, size: 100),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        widget.product['name'] ?? 'Unknown Product',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 2,
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: RichText(
                        text: TextSpan(
                          text:
                              widget.product['description'] ?? 'No description',
                          style: TextStyle(
                              fontSize: 16,
                              color: const Color.fromARGB(255, 100, 100, 100),
                              fontWeight: FontWeight.normal),
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Available Sizes:\n',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children:
                          (widget.product['availableSizes'] as List<dynamic>?)
                                  ?.map((size) => Container(
                                        constraints: BoxConstraints(
                                          maxWidth: 50,
                                          minHeight: 50,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _selectedSize = size;
                                            });

                                            print('Selected size: $size');
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: _selectedSize == size
                                                  ? Colors.blue
                                                  : Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              border: Border.all(
                                                color: _selectedSize == size
                                                    ? Colors.blue
                                                    : Colors.transparent,
                                                width: 2,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                size.toString(),
                                                style: TextStyle(
                                                  color: _selectedSize == size
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList() ??
                              [Text('No sizes available')],
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Available Colors:\n',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children:
                          (widget.product['availableColors'] as List<dynamic>?)
                                  ?.map((colorName) => GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedColor = colorName;
                                          });
                                          print('Selected color: $colorName');
                                        },
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: _getColorFromName(colorName),
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            border: Border.all(
                                              color: _selectedColor == colorName
                                                  ? Colors.white
                                                  : Colors.transparent,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList() ??
                              [Text('No colors available')],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 90,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      'Price: \$${widget.product['price'] ?? '0.00'}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: _addToCart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text('Add to cart'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
