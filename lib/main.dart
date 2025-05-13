import 'package:project_v1/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_v1/provider/card_provider.dart';
import 'package:project_v1/provider/user_provider.dart';
import 'package:project_v1/provider/order_provider.dart';
import 'package:project_v1/screens/login/signin.dart';
import 'package:project_v1/screens/profile/profile.dart';
import 'package:project_v1/screens/tabs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()), // CartProvider
        ChangeNotifierProvider(create: (_) => UserProvider()), // UserProvider
        ChangeNotifierProvider(create: (_) => OrderProvider()),
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
        primarySwatch: Colors.blue,
      ),
      home: const Signin(), // Pantalla inicial de inicio de sesión
      routes: {
        '/profile': (context) =>
            const Profile(), // Ruta a la pantalla de perfil
        '/main': (context) =>
            const TabsScreen(), // Ruta a la pantalla principal (TabsScreen)
      },
    );
  }
}
