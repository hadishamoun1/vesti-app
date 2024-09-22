import 'package:flutter/material.dart';

class CategoryChips extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  CategoryChips({
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    var primarry_color = Color.fromARGB(255, 202, 202, 202);
    var secondary_color = Color(0xFF3882cd);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: categories.map((category) {
          return GestureDetector(
            onTap: () {
              onCategorySelected(category);
            },
            child: Chip(
              label: Text(
                category,
                style: TextStyle(
                  color: selectedCategory == category
                      ? Colors.white // Text color when selected
                      : Colors.black, // Text color when not selected
                ),
              ),
              padding: EdgeInsets.all(2),
              backgroundColor: selectedCategory == category
                  ? secondary_color
                  : Colors.white,
              side: BorderSide(
                color: selectedCategory == category
                    ? secondary_color // Border color when selected
                    : primarry_color, // Border color when not selected
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
