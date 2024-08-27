import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Container(), 
    );
  }
}
class CartItem {
  final String name;
  final double price;
  int quantity;

  CartItem({required this.name, required this.price, this.quantity = 1});
}