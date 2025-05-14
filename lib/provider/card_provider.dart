import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_v1/services/auth_service.dart';
import '../models/productos.dart';

class CartItem {
  final Producto producto;
  int cantidad;

  CartItem({required this.producto, this.cantidad = 1});
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  CartProvider(AuthService authService);

  List<CartItem> get items => _items;

  /// Método para agregar un producto al carrito y reducir el stock en Firebase
  Future<void> addToCart(Producto producto) async {
    if (producto.stock > 0) {
      final index = _items.indexWhere((item) => item.producto.id == producto.id);
      if (index >= 0) {
        _items[index].cantidad++;
      } else {
        _items.add(CartItem(producto: producto));
      }

      // Reducir el stock en Firebase
      try {
        final docRef = FirebaseFirestore.instance.collection('productos').doc(producto.id);
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final snapshot = await transaction.get(docRef);

          if (!snapshot.exists) {
            throw Exception('El producto no existe en la base de datos');
          }

          final data = snapshot.data() as Map<String, dynamic>;
          final stockActual = data['stock'] ?? 0;

          if (stockActual <= 0) {
            throw Exception('Stock insuficiente');
          }

          transaction.update(docRef, {'stock': stockActual - 1});
        });

        notifyListeners();
      } catch (e) {
        throw Exception('Error al actualizar el stock: $e');
      }
    } else {
      throw Exception('El producto no tiene stock disponible');
    }
  }

  void removeFromCart(Producto producto) {
    _items.removeWhere((item) => item.producto.id == producto.id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  int get totalItems => _items.fold(0, (sum, item) => sum + item.cantidad);

  double get totalPrice => _items.fold(
      0, (sum, item) => sum + (item.producto.precio * item.cantidad));
}