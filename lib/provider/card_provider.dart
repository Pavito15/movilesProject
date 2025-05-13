import 'package:flutter/material.dart';
import '../models/productos.dart';

class CartItem {
  final Producto producto;
  int cantidad;

  CartItem({required this.producto, this.cantidad = 1});
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addToCart(Producto producto) {
    final index = _items.indexWhere((item) => item.producto.id == producto.id);
    if (index >= 0) {
      _items[index].cantidad++;
    } else {
      _items.add(CartItem(producto: producto));
    }
    notifyListeners(); // Notifica a los widgets que escuchan cambios
  }

  void removeFromCart(Producto producto) {
    _items.removeWhere((item) => item.producto.id == producto.id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear(); // Vacía la lista de productos en el carrito
    notifyListeners(); // Notifica a los widgets que escuchan cambios
  }

  int get totalItems => _items.fold(0, (sum, item) => sum + item.cantidad);

  double get totalPrice => _items.fold(
      0, (sum, item) => sum + (item.producto.precio * item.cantidad));
}
