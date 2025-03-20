import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;

  const CustomIconButton({
    super.key,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(2),
        minimumSize: const Size(50, 50),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      child: ClipOval(
        child: Image.asset(
          imagePath,
          fit: BoxFit.fill,
          width: 50,
          height: 50,
        ),
      ),
    );
  }
}
