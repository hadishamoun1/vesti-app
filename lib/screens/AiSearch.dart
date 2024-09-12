import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  File? _image;
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
    // Fetch search results here
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
                  : Image.file(_image!, fit: BoxFit.cover),
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: _image == null
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
    List<String> searchResults = [
      'Result 1',
      'Result 2',
      'Result 3',
    ];

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(searchResults[index]),
            subtitle: Text('Additional details'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        );
      },
    );
  }
}
