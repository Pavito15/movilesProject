import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color textColor;
  final FontWeight fontWeight;
  final double fontSize;
  final TextDecoration decoration;

  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor = Colors.black,
    this.fontWeight = FontWeight.w600,
    this.fontSize = 16.0,
    this.decoration = TextDecoration.underline,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: fontWeight,
          fontSize: fontSize,
          decoration: decoration,
        ),
      ),
    );
  }
}
