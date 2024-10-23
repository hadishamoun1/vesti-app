import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'ProductDetails.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  File? _image;
  List<Map<String, dynamic>> _matchedProducts = [];
  bool _isLoading = false;
  final picker = ImagePicker();
  final PY_Url = dotenv.env['PY_URL'];
  final apiUrl = dotenv.env['API_URL'];

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _fetchSearchResults();
      }
    });
  }

  Future<void> _fetchSearchResults() async {
    if (_image == null) return;

    setState(() {
      _isLoading = true;
    });

    var request = http.MultipartRequest('POST', Uri.parse('$PY_Url/upload/'));
    request.files.add(await http.MultipartFile.fromPath('file', _image!.path));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseBody);
        List<String> uploadedImageNames =
            List<String>.from(jsonResponse['similar_images']);

        // Fetch products and match image names
        await _fetchProductData(uploadedImageNames);
      } else {
        print('Failed to upload image: ${response.statusCode}');
        setState(() {
          _matchedProducts = [];
        });
      }
    } catch (e) {
      print('Error uploading image: $e');
      setState(() {
        _matchedProducts = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchProductData(List<String> uploadedImageNames) async {
    try {
      var response = await http.get(Uri.parse('$apiUrl/products'));
      if (response.statusCode == 200) {
        List<dynamic> products = json.decode(response.body);

        List<Map<String, dynamic>> matchedProducts = [];
        for (var product in products) {
          String productImageUrl = product['imageUrl'];

          // Match uploaded image name with product image name
          for (var imageName in uploadedImageNames) {
            String expectedImageUrl = '/productImages/$imageName';
            print('uploads image: $expectedImageUrl');
            print('Product image: $productImageUrl');
            if (expectedImageUrl == productImageUrl) {
              matchedProducts.add(product);
            }
          }
        }

        setState(() {
          _matchedProducts = matchedProducts;
        });
      } else {
        print('Failed to fetch products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 225, 242, 252),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: _image == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/projImages/upload_pic.png',
                          height: 80,
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Tap to upload an image',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 114, 114, 114)),
                        ),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Image.file(
                              _image!,
                              fit: BoxFit.contain,
                            ),
                    ),
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: _matchedProducts.isEmpty
                ? Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_fix_high,
                          color: Color.fromARGB(255, 114, 114, 114),
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Upload an image to see similar results',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 114, 114, 114),
                          ),
                        ),
                      ],
                    ),
                  )
                : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.68,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: _matchedProducts.length,
      itemBuilder: (context, index) {
        var product = _matchedProducts[index];
        return GestureDetector(
          onTap: () {
            // Navigate to the ProductDetailsPage when the card is tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailsPage(product: product),
              ),
            );
          },
          child: Card(
            elevation: 3.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      'http://10.0.2.2:3000${product['imageUrl']}',
                      height: 170,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    product['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    product['description'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[700],
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Price: \$${product['price']}',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
