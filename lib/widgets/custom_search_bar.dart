import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;

  CustomSearchBar({
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 5, 16, 16),
      child: TextField(
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey[500],
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Colors.grey[300]!,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1.5,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
        ),
      ),
    );
  }
}
