import 'package:flutter/material.dart';

class ProductDetailsPage extends StatefulWidget {
  final dynamic product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  String? _selectedSize;
  String? _selectedColor;

  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'yellow':
        return Colors.yellow;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Product Details'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Image.network(
                      widget.product['imageUrl'] ?? '',
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
                        widget.product['name'] ?? 'Unknown Product',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
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
                              text: widget.product['description'] ??
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
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
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
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children:
                          (widget.product['availableSizes'] as List<dynamic>?)
                                  ?.map((size) => Container(
                                        constraints: BoxConstraints(
                                          maxWidth: 50,
                                          minHeight: 50,
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _selectedSize = size;
                                            });
                                            
                                            print('Selected size: $size');
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: _selectedSize == size
                                                  ? Colors.blue
                                                  : Colors.grey[
                                                      200], 
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              border: Border.all(
                                                color: _selectedSize == size
                                                    ? Colors.blue
                                                    : Colors
                                                        .transparent, 
                                                width: 2,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                size.toString(),
                                                style: TextStyle(
                                                  color: _selectedSize == size
                                                      ? Colors.white
                                                      : Colors
                                                          .black, 
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList() ??
                              [Text('No sizes available')],
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
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
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children:
                          (widget.product['availableColors'] as List<dynamic>?)
                                  ?.map((colorName) => GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedColor = colorName;
                                          });
                                          // Handle color selection
                                          print('Selected color: $colorName');
                                        },
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: _getColorFromName(
                                                colorName),
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            border: Border.all(
                                              color: _selectedColor == colorName
                                                  ? Colors.white
                                                  : Colors
                                                      .transparent, 
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList() ??
                              [Text('No colors available')],
                    ),
                  ],
                ),
              ),
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
              mainAxisAlignment:
                  MainAxisAlignment.end, 
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      'Price: \$${widget.product['price'] ?? '0.00'}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        // Handle button press
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(5), 
                        ),
                      ),
                      child: Text('Add to cart'),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                  
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('View Store'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
