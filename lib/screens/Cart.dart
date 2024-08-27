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

  double get totalPrice {
    return cartItems.fold(
        0.0, (total, item) => total + (item.price * item.quantity));
  }

  void _incrementQuantity(int index) {
    setState(() {
      cartItems[index].quantity++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${cartItems[index].quantity}x'),
                    ),
                    title: Text(cartItems[index].name),
                    subtitle:
                        Text('\$${cartItems[index].price.toStringAsFixed(2)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () => _decrementQuantity(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => _incrementQuantity(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
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
