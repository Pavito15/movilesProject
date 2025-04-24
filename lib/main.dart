import 'package:flutter/material.dart';
import 'package:project_v1/provider/cardProvider.dart';
import 'package:project_v1/screens/tabs.dart';
import 'package:project_v1/screens/login/signin.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()), // Registra el CartProvider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CLEORGANIC',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const TabsScreen(), // Se inicia con TabsScreen
        '/profile': (context) => const Signin(),
      },
    );
  }
}
