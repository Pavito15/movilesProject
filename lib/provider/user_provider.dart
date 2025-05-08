import 'package:flutter/material.dart';
import 'package:project_v1/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  // Actualizar el usuario en el provider
  void setUser(UserModel user) {
    _user = user;
    notifyListeners(); // Notifica a los oyentes para que actualicen la UI
  }

  // Función para obtener los datos del usuario desde Firestore
  Future<void> getUserData(String uid) async {
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        // Aquí usamos el factory fromFirestore para crear el modelo desde Firestore
        final user = UserModel.fromFirestore(userDoc.data()!, uid);
        setUser(user); // Actualiza el estado con los datos obtenidos
      }
    } catch (e) {
      print("Error al obtener los datos del usuario: $e");
    }
  }

  // Función para actualizar la información del usuario
  Future<void> updateUser(UserModel updatedUser) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(updatedUser.uid)
          .update(updatedUser.toMap());

      // Después de actualizar, también actualizamos el modelo en el provider
      setUser(updatedUser);
    } catch (e) {
      print("Error al actualizar los datos del usuario: $e");
    }
  }

  // Función para borrar el usuario
  Future<void> deleteUser(String uid) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
      _user = null; // Restablece el estado del usuario
      notifyListeners();
    } catch (e) {
      print("Error al eliminar el usuario: $e");
    }
  }
}
