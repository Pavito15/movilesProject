import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Clase que maneja eventos relacionados con la autenticación
class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;

  AuthService() {
    // Escuchar cambios en el estado de autenticación
    _auth.authStateChanges().listen((User? user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  User? get currentUser => _currentUser;

  /// Obtiene el ID del usuario actual, o null si no hay usuario
  String? get userId => _currentUser?.uid;

  /// Verifica si hay un usuario autenticado
  bool get isAuthenticated => _currentUser != null;

  /// Cierra la sesión del usuario actual
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
