import 'package:flutter/material.dart';

import '../widgets/OpenStreetMap.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> cartItems = [
    CartItem(name: 'T-Shirt', price: 20.0, quantity: 1),
    CartItem(name: 'Jeans', price: 40.0, quantity: 2),
    CartItem(name: 'Sneakers', price: 60.0, quantity: 1),
  ];

  List<double> paddingValues = [0.0, 0.0, 0.0]; // Padding state for each item

  double get totalPrice {
    return cartItems.fold(
        0.0, (total, item) => total + (item.price * item.quantity));
  }

  int get totalItems {
    return cartItems.fold(0, (total, item) => total + item.quantity);
  }

  void _onCheckout() {
    print('Checkout pressed');
  }

  void _incrementQuantity(int index) {
    setState(() {
      cartItems[index].quantity++;
      paddingValues[index] = 10.0; // Move the card forward
    });

    // Reset the padding after a short delay for smooth animation
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
        paddingValues[index] = 10.0; // Move the card forward
      }
    });

    // Reset the padding after a short delay for smooth animation
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        paddingValues[index] = 0.0;
      });
    });
  }

  void _removeCartItem(int index) {
    setState(() {
      cartItems.removeAt(index);
      paddingValues.removeAt(index);
    });
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
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.only(
                      left: paddingValues[index]), // Animated padding
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
                              // Image container
                              Container(
                                width: 120,
                                height: 110,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.image, color: Colors.grey),
                              ),
                              SizedBox(width: 10),
                              // Item details and quantity centered vertically
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
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 10),
                                        // CircleAvatar showing the quantity beside the name
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
                                    // Row to align price with increment/decrement buttons
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: ',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${totalPrice.toStringAsFixed(2)}',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OpenStreetMapScreen()),
                      );
                    },
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

class CartItem {
  final String name;
  final double price;
  int quantity;

  CartItem({required this.name, required this.price, this.quantity = 1});
}
