import 'package:flutter/material.dart';

class DashedDivider extends StatelessWidget {
  final double dashWidth;
  final double dashHeight;
  final double dashSpacing;
  final Color color;
  final double width; 
  final Alignment alignment; 

  DashedDivider({
    this.dashWidth = 10.0,
    this.dashHeight = 2.0,
    this.dashSpacing = 4.0,
    this.color = const Color.fromARGB(255, 196, 196, 196),
    this.width = double.infinity, 
    this.alignment = Alignment.center, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, 
      alignment: alignment, 
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
