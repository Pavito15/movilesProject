import 'package:flutter/material.dart';
import '../widgets/home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onTabSelected});

  final Function(int) onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: HomeWidget(onTabSelected: onTabSelected),
      ),
    );
  }
}
