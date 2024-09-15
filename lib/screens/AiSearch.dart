import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  File? _image;
  List<String> _similarImages = [];
  bool _isLoading = false; // Add a loading state
  final picker = ImagePicker();

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
      _isLoading = true; // Set loading to true when starting fetch
    });

    // Create a multipart request
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://10.0.2.2:8000/upload/'));
    request.files.add(await http.MultipartFile.fromPath('file', _image!.path));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseBody);

        setState(() {
          _similarImages = List<String>.from(jsonResponse['similar_images']);
        });
      } else {
        // Handle the error
        print('Failed to upload image: ${response.statusCode}');
        setState(() {
          _similarImages = []; // Clear the previous results
        });
      }
    } catch (e) {
      print('Error uploading image: $e');
      setState(() {
        _similarImages = []; // Clear the previous results
      });
    } finally {
      setState(() {
        _isLoading = false; // Set loading to false when fetch is done
      });
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
              height: 200,
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
                              child:
                                  CircularProgressIndicator(), 
                            )
                          : Image.file(
                              _image!,
                              fit: BoxFit.fill,
                            ),
                    ),
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: _similarImages.isEmpty
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
    return ListView.builder(
      itemCount: _similarImages.length,
      itemBuilder: (context, index) {
        String imageUrl =
            'http://10.0.2.2:3000/productImages/${_similarImages[index]}';
        return Card(
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              child: Image.network(imageUrl,
                  width: 50, height: 50, fit: BoxFit.cover),
            ),
            title: Text('Similar Image ${index + 1}'),
            subtitle: Text('Additional details for image'),
          ),
        );
      },
    );
  }
}
