import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import './Checkout.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> cartItems = [];
  List<double> paddingValues = [];
  double totalAmount = 0.0;
  Map<String, String> productImages = {}; 

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
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

  Future<void> _fetchCartItems() async {
    final userId = await _getUserIdFromToken();

    if (userId != null) {
      final response = await http.get(
          Uri.parse('http://10.0.2.2:3000/order-items/cart?userId=$userId'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('DATA FETCHED: $data');
        final items = data['cartItems'] as List;
        print('iTEMS FETCHED: $items');
        final fetchedItems = items
            .map((item) => CartItem(
                  productId: item['productId'].toString(),
                  name: item['name'],
                  price: double.parse(item['price']),
                  quantity: item['quantity'],
                  sizes: item['Sizes'] != null
                      ? List<String>.from(item['Sizes'])
                      : [], 
                  colors: item['Colors'] != null
                      ? List<String>.from(item['Colors'])
                      : [], 
                  storeId: item['storeId'].toString(),
                  orderId: item['orderId'].toString(),
                ))
            .toList();

        setState(() {
          cartItems = fetchedItems;
          totalAmount = double.parse(data['totalAmount']);
          paddingValues =
              List<double>.generate(cartItems.length, (index) => 0.0);
        });

        for (var item in fetchedItems) {
          await _fetchProductImage(item.productId);
        }
      } else {
        print('Failed to load cart items');
      }
    } else {
      print('User ID not found in shared preferences');
    }
  }

  Future<void> _fetchProductImage(String productId) async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:3000/products/$productId'));

      if (response.statusCode == 200) {
        final productData = jsonDecode(response.body);
        final imageUrl = productData['imageUrl'];

        setState(() {
          productImages[productId] = imageUrl;
        });
      } else {
        print('Failed to load image for product: $productId');
      }
    } catch (e) {
      print('Error fetching image: $e');
    }
  }

  double _calculateTotalAmount() {
    return cartItems.fold(
        0.0, (total, item) => total + (item.price * item.quantity));
  }

  double get totalPrice {
    return cartItems.fold(
        0.0, (total, item) => total + (item.price * item.quantity));
  }

  int get totalItems {
    return cartItems.fold(0, (total, item) => total + item.quantity);
  }

  void _incrementQuantity(int index) {
    setState(() {
      cartItems[index].quantity++;
      paddingValues[index] = 10.0;
      totalAmount = _calculateTotalAmount();
    });

    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        paddingValues[index] = 0.0;
      });
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
        paddingValues[index] = 10.0;
        totalAmount = _calculateTotalAmount();
      }
    });

    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        paddingValues[index] = 0.0;
      });
    });
  }

  void _removeCartItem(int index) async {
    final cartItem = cartItems[index];
    final response = await http.delete(
      Uri.parse(
          'http://10.0.2.2:3000/order-items/product/${cartItem.productId}'),
    );

    if (response.statusCode == 200) {
      setState(() {
       
        cartItems.removeAt(index);
        paddingValues.removeAt(index); 
        totalAmount = _calculateTotalAmount();
      });
    } else {
      print(
          'Failed to delete cart item: ${response.statusCode} - ${response.body}');
    }
  }

  void _onCheckout() async {
    final userId = await _getUserIdFromToken();
    if (userId != null) {
      final items = cartItems
          .map((item) => {
                'productId': item.productId,
                'quantity': item.quantity,
                'Sizes': item.sizes,
                'Colors': item.colors
              })
          .toList();

      print('Items to be sent: ${jsonEncode(items)}');

      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/orders/update-cart'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'storeId': cartItems.isNotEmpty ? cartItems[0].storeId : null,
          'items': items,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        double totalAmount;
        try {
          totalAmount = double.parse(data['totalAmount'].toString());
        } catch (e) {
          print('Error parsing totalAmount: $e');
          totalAmount = 0.0;
        }

        setState(() {
          this.totalAmount = totalAmount;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(
              cartItems: cartItems,
              totalItems: totalItems,
              totalPrice: totalAmount,
              orderId: cartItems[0].orderId,
            ),
          ),
        );
      } else {
        print('Failed to update cart');
      }
    } else {
      print('User ID not found in shared preferences');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Your Cart'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final productImage = productImages[cartItems[index].productId];
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.only(left: paddingValues[index]),
                  child: Card(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Stack(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 120,
                                height: 110,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      10.0), 
                                  child: Image.network(
                                    getImageUrl(productImage ?? ''),
                                    fit: BoxFit.fill,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Icon(Icons.error, size: 100),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          cartItems[index].name,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(width: 10),
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundColor: Colors.blue,
                                          child: Text(
                                            '${cartItems[index].quantity}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '\$${cartItems[index].price.toStringAsFixed(2)}',
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.remove,
                                                color: Colors.red,
                                              ),
                                              onPressed: () =>
                                                  _decrementQuantity(index),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.add,
                                                color: Colors.blue,
                                              ),
                                              onPressed: () =>
                                                  _incrementQuantity(index),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: Icon(Icons.close, color: Colors.red),
                              onPressed: () => _removeCartItem(index),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            height: 160,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    'Total Items: $totalItems',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: ',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '\$${totalAmount.toStringAsFixed(2)}',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: _onCheckout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      fixedSize: Size(400, 45),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Go to checkout',
                      style: TextStyle(fontSize: 21),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String getImageUrl(String relativePath) {
  return 'http://10.0.2.2:3000$relativePath';
}

class CartItem {
  final String productId;
  final String name;
  final double price;
  int quantity;
  final List<String> sizes;
  final List<String> colors;
  final String storeId;
  final String orderId;

  CartItem(
      {required this.productId,
      required this.name,
      required this.price,
      required this.quantity,
      required this.sizes,
      required this.colors,
      required this.storeId,
      required this.orderId});
  @override
  String toString() {
    return 'CartItem(productId: $productId, name: $name, price: $price, quantity: $quantity, sizes: $sizes, colors: $colors, storeId: $storeId, orderId: $orderId)';
  }
}
