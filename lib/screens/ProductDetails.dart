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

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: RichText(
                  text: TextSpan(
                    text: 'Description:\n\n',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: product['description'] ??
                            'No description available',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10), // Reduced space between sections

              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 4.0), // Reduced vertical padding
                child: RichText(
                  text: TextSpan(
                    text: 'Available Sizes:\n',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Display sizes as buttons
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: (product['availableSizes'] as List<dynamic>?)
                        ?.map((size) => ElevatedButton(
                              onPressed: () {
                                // Handle size selection
                                print('Selected size: $size');
                              },
                              child: Text(size.toString()),
                            ))
                        .toList() ??
                    [Text('No sizes available')],
              ),
              SizedBox(height: 20), // Space between sizes and colors section
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 4.0), // Reduced vertical padding
                child: RichText(
                  text: TextSpan(
                    text: 'Available Colors:\n',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Display colors as buttons
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: (product['availableColors'] as List<dynamic>?)
                        ?.map((color) => ElevatedButton(
                              onPressed: () {
                                // Handle color selection
                                print('Selected color: $color');
                              },
                              child: Text(color.toString()),
                            ))
                        .toList() ??
                    [Text('No colors available')],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
