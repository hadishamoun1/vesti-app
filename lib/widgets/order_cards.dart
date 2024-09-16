import 'package:flutter/material.dart';
import '../models/order_model.dart';

class OrderGrid extends StatelessWidget {
  final List<Order> orders;

  OrderGrid({required this.orders});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 0.58,
      ),
      padding: const EdgeInsets.all(8.0),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return OrderCard(order: orders[index]);
      },
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;

  OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with Border Radius
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(8.0), // Adjust the radius as needed
              child: Image.network(
                getImageUrl(order.orderItems[0].product.imageUrl),
                height: 130,
                width: double.infinity,
                fit: BoxFit
                    .fill, // Use BoxFit.cover for better aspect ratio handling
              ),
            ),
            SizedBox(height: 8),

            // Order Number
            Text(
              'Order #${order.id}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),

            // Store Name
            Text(
              'Store: ${order.orderItems[0].product.store.name}',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
            ),
            SizedBox(height: 8),

            // Status
            Text('Status: ${order.status}'),
            SizedBox(height: 8),

            // Quantity
            Text('Quantity: ${order.orderItems[0].quantity}'),
            SizedBox(height: 8),

            // Size
            Text('Size: ${order.orderItems[0].sizes.join(", ")}'),
            SizedBox(height: 8),

            // Price
            Text('Price: \$${order.orderItems[0].priceAtPurchase}'),
            SizedBox(height: 8),

            Text('Total: \$${order.totalAmount}'),
          ],
        ),
      ),
    );
  }

  String getImageUrl(String relativePath) {
    return 'http://10.0.2.2:3000$relativePath';
  }
}
