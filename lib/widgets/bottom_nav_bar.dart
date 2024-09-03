import 'package:flutter/material.dart';

var primaryColor = Color.fromARGB(255, 202, 202, 202);
var secondaryColor = Color(0xFF3882cd);

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  BottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 5,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIconButton(
            icon: Icons.home_outlined,
            index: 0,
          ),
          _buildIconButton(
            icon: Icons.search,
            index: 1,
          ),
          _buildIconButton(
            icon: Icons.auto_awesome_outlined,
            index: 2,
          ),
          _buildIconButton(
            icon: Icons.person_outline,
            index: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({required IconData icon, required int index}) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: currentIndex == index ? secondaryColor : Colors.transparent,
        ),
        child: Icon(
          icon,
          color: currentIndex == index ? Colors.white : Colors.grey,
          size: 32,
        ),
      ),
    );
  }
}
