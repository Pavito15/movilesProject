import 'package:project_v1/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_v1/screens/login/signin.dart';
import 'package:project_v1/screens/profile/profile.dart';
import 'package:project_v1/screens/tabs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
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
      // AuthGate to home
      home: const Signin(),
      routes: {
        '/profile': (context) => const Profile(),
        '/main': (context) => const TabsScreen(),
      },
    );
  }
}
