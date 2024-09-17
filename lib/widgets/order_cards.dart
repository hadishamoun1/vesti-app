import 'package:flutter/material.dart';
import '../models/order_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
        childAspectRatio: 0.55,
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
  final String? apiUrl = dotenv.env['API_URL'];

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
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                getImageUrl(order.orderItems[0].product.imageUrl),
                width: double.infinity,
                height: 130,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: 8),

            Text(
              'Order #${order.id}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF3882cd),
              ),
            ),
            SizedBox(height: 8),

            Text(
              'Store: ${order.orderItems[0].product.store.name}',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),

            // Status
            Text(
              'Status: ${order.status}',
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),

            // Quantity
            Text(
              'Quantity: ${order.orderItems[0].quantity}',
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),

            // Size
            Text(
              'Size: ${order.orderItems[0].sizes.join(", ")}',
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),

            // Price
            Text(
              'Price: \$${order.orderItems[0].priceAtPurchase}',
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),

            // Total
            Text(
              'Total: \$${order.totalAmount}',
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  String getImageUrl(String relativePath) {
    return '$apiUrl$relativePath';
  }
}
