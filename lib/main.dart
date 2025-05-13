import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:project_v1/firebase_options.dart';
import 'package:project_v1/provider/card_provider.dart';
import 'package:project_v1/provider/user_provider.dart';
import 'package:project_v1/provider/theme_provider.dart';
import 'package:project_v1/provider/order_provider.dart';
import 'package:project_v1/services/auth_service.dart';
import 'package:project_v1/screens/login/signin.dart';
import 'package:project_v1/screens/profile/profile.dart';
import 'package:project_v1/screens/tabs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Stripe.publishableKey =
      'pk_test_51RODr0Fh3PHwMx28WQvJLMRJwsgFenk01fGvgdaT6mGcQPpxJxJITBjrm8etEuy7jvDaOEyDIYl96kpZSs7qTiBh00Wx9TREdw';

  runApp(
    MultiProvider(
      providers: [
        // Provider para el tema
        ChangeNotifierProvider(create: (_) => ThemeProvider()),

        // Primero creamos el servicio de autenticación
        ChangeNotifierProvider(create: (_) => AuthService()),

        // Luego los providers que dependen del AuthService
        ChangeNotifierProxyProvider<AuthService, CartProvider>(
          create: (context) => CartProvider(context.read<AuthService>()),
          update: (context, authService, previous) =>
              previous ?? CartProvider(authService),
        ),
        ChangeNotifierProxyProvider<AuthService, UserProvider>(
          create: (context) => UserProvider(context.read<AuthService>()),
          update: (context, authService, previous) =>
              previous ?? UserProvider(authService),
        ),
        ChangeNotifierProxyProvider<AuthService, OrderProvider>(
          create: (context) => OrderProvider(context.read<AuthService>()),
          update: (context, authService, previous) =>
              previous ?? OrderProvider(authService),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'CLEORGANIC',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            primarySwatch: Colors.blue,
          ),
          darkTheme: ThemeData(
            scaffoldBackgroundColor: Colors.black,
            primarySwatch: Colors.blue,
            brightness: Brightness.dark,
          ),
          themeMode: themeProvider.themeMode, // Escucha el ThemeProvider
          home: const Signin(), // Pantalla inicial de inicio de sesión
          routes: {
            '/profile': (context) =>
                const Profile(), // Ruta a la pantalla de perfil
            '/main': (context) =>
                const TabsScreen(), // Ruta a la pantalla principal (TabsScreen)
          },
        );
      },
    );
  }
}
