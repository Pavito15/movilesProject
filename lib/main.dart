import 'package:flutter/material.dart';
import '../screens/home_screens.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CLEORGANIC',
       home: const HomeScreen(),
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'CLEORGANIC',
//       initialRoute: '/',
//       routes: {
//         '/': (context) => const HomeScreen(),
//         '/profile': (context) => const ProfileScreen(),
//         '/cart': (context) => const CartScreen(),
//       },
//     );
//   }
// }