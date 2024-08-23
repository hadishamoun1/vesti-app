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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
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
              // Description section with padding
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: RichText(
                  text: TextSpan(
                    text: 'Description:\n\n', // Added extra newline for spacing
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: product['description'] ??
                            'No description available',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Available Sizes section with padding
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: RichText(
                  text: TextSpan(
                    text:
                        'Available Sizes:\n\n', // Added extra newline for spacing
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: product['availableSizes']?.join(", ") ??
                            'No sizes available',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Available Colors section with padding
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: RichText(
                  text: TextSpan(
                    text:
                        'Available Colors:\n\n', // Added extra newline for spacing
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: product['availableColors']?.join(", ") ??
                            'No colors available',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
