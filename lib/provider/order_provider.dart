import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_v1/models/order_model.dart';
import 'package:project_v1/services/auth_service.dart';

class OrderProvider extends ChangeNotifier {
  final AuthService _authService;
  List<UserOrder> _orders = [];
  bool _isLoading = false;

  // Constructor que recibe el AuthService
  OrderProvider(this._authService) {
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
    // Limpiar pedidos cuando el usuario cierra sesión
    if (!_authService.isAuthenticated) {
      clearOrders();
    } else {
      // Si hay un usuario autenticado, cargar sus pedidos
      fetchOrders();
    }
  }

  List<UserOrder> get orders => _orders;
  bool get isLoading => _isLoading;

  // Método para limpiar los pedidos
  void clearOrders() {
    _orders = [];
    notifyListeners();
    debugPrint('Orders cleared');
  }

  Future<void> fetchOrders() async {
    try {
      // Si no hay usuario autenticado, salir
      if (!_authService.isAuthenticated) return;

      final userId = _authService.userId;
      if (userId == null) return;

      _isLoading = true;
      notifyListeners();

      debugPrint('Fetching orders for user: $userId');

      final snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      debugPrint('Found ${snapshot.docs.length} orders');

      if (snapshot.docs.isEmpty) {
        _orders = [];
        _isLoading = false;
        notifyListeners();
        return;
      }

      _orders = snapshot.docs
          .map((doc) {
            try {
              return UserOrder.fromFirestore(doc.data(), doc.id);
            } catch (e) {
              debugPrint('Error mapping order ${doc.id}: $e');
              return null;
            }
          })
          .whereType<UserOrder>()
          .toList();

      debugPrint('Mapped ${_orders.length} orders successfully');
    } catch (e) {
      debugPrint('Error fetching orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
