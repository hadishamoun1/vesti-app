import 'package:flutter/material.dart';

class ProductDetailsPage extends StatelessWidget {
  final dynamic product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Image.network(
                product['imageUrl'] ?? '',
                height: 200,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error, size: 100);
                },
              ),
              SizedBox(height: 10),

              // Adding padding to the product name text
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 8, 8),
                child: Text(
                  product['name'] ?? 'Unknown Product',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(
                color: Colors.black,
                thickness: 2,
              ),
              SizedBox(height: 10),
              Text(
                'Description: ${product['description'] ?? 'No description available'}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Price: \$${product['price']?.toString() ?? 'Unknown'}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Available Sizes: ${product['availableSizes']?.join(", ") ?? 'No sizes available'}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Available Colors: ${product['availableColors']?.join(", ") ?? 'No colors available'}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
