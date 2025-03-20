import 'package:flutter/material.dart';

class CustomImageAvatar extends StatelessWidget {
  final double radius;
  final String imagePath;
  final Color backgroundColor;

  const CustomImageAvatar({
    super.key,
    this.radius = 60.0,
    required this.imagePath,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: ClipOval(
        child: Image.asset(
          imagePath,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover, 
        ),
      ),
    );
  }
}
