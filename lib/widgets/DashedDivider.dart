import 'package:flutter/material.dart';

class DashedDivider extends StatelessWidget {
  final double dashWidth;
  final double dashHeight;
  final double dashSpacing;
  final Color color;
  final double width; // Added parameter for width
  final Alignment alignment; // Added parameter for alignment

  DashedDivider({
    this.dashWidth = 10.0,
    this.dashHeight = 2.0,
    this.dashSpacing = 4.0,
    this.color = Colors.black,
    this.width = double.infinity, // Default to full width
    this.alignment = Alignment.center, // Default to center alignment
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, // Use the width parameter
      alignment: alignment, // Use the alignment parameter
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          (width / (dashWidth + dashSpacing)).floor(),
          (index) => Container(
            width: dashWidth,
            height: dashHeight,
            color: color,
            margin: EdgeInsets.symmetric(horizontal: dashSpacing / 2),
          ),
        ),
      ),
    );
  }
}
