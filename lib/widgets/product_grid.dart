import 'package:flutter/material.dart';
import '../screens/ProductDetails.dart';

class ProductGrid extends StatelessWidget {
  final List<dynamic> products;

  ProductGrid({required this.products});

  @override
  Widget build(BuildContext context) {
    print(products);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.8,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsPage(
                    product: product,
                  ),
                ),
              );
            },
            child: Card(
              color: const Color.fromARGB(255, 236, 243, 248),
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(8.0)),
                      child: Image.network(
                        getImageUrl(
                          product['imageUrl'] ?? '',
                        ),
                        width: double.infinity,
                        fit: BoxFit.fill,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.error, size: 100);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        product['name'] ?? 'Unknown Product',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '\$${product['price']}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String getImageUrl(String relativePath) {
    final baseUrl = 'http://10.0.2.2:3000';
    return '$baseUrl$relativePath';
  }
}
