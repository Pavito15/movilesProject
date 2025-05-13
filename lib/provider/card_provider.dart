import 'package:flutter/material.dart';
import '../models/productos.dart';
import '../services/auth_service.dart';

class CartItem {
  final Producto producto;
  int cantidad;

  CartItem({required this.producto, this.cantidad = 1});
}

class CartProvider extends ChangeNotifier {
  final AuthService _authService;
  final List<CartItem> _items = [];

  // Constructor que recibe el AuthService
  CartProvider(this._authService) {
    // Escuchar cambios en la autenticación
    _authService.addListener(_onAuthChanged);
  }

  @override
  void dispose() {
    // Importante remover el listener para evitar memory leaks
    _authService.removeListener(_onAuthChanged);
    super.dispose();
  }

  // Este método se ejecuta cada vez que cambia el estado de autenticación
  void _onAuthChanged() {
    // Limpiar carrito cuando el usuario cambia
    clearCart();
  }

  List<CartItem> get items => _items;

  void addToCart(Producto producto) {
    final index = _items.indexWhere((item) => item.producto.id == producto.id);
    if (index >= 0) {
      _items[index].cantidad++;
    } else {
      _items.add(CartItem(producto: producto));
    }
    notifyListeners();
  }

  void removeFromCart(Producto producto) {
    _items.removeWhere((item) => item.producto.id == producto.id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
    debugPrint('Cart cleared');
  }

  int get totalItems => _items.fold(0, (sum, item) => sum + item.cantidad);

  double get totalPrice => _items.fold(
      0, (sum, item) => sum + (item.producto.precio * item.cantidad));
}
