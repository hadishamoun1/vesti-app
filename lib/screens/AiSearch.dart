import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../widgets/bottom_nav_bar.dart';
import 'Home.dart';
import 'SearchStores.dart';
import 'Profile.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  File? _image;
  final picker = ImagePicker();
  int _currentIndex = 2; 

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

  void _onBottomNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SearchStoresPage()),
      );
    } else if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SearchScreen()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Search'),
        centerTitle: true,
      ),
      body: Container(
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
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: _image == null
                    ? Center(child: Text('Tap to upload an image'))
                    : Image.file(_image!, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: _image == null
                  ? Center(child: Text('Upload an image to see results'))
                  : _buildSearchResults(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTapped,
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
