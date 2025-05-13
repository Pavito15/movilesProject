import 'package:cloud_firestore/cloud_firestore.dart';

class UserOrder {
  final String id;
  final String userId;
  final List<OrderProduct> products;
  final double total;
  final String status;
  final DateTime createdAt;

  UserOrder({
    required this.id,
    required this.userId,
    required this.products,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  factory UserOrder.fromFirestore(Map<String, dynamic> data, String documentId) {
    return UserOrder(
      id: documentId,
      userId: data['userId'],
      products: (data['products'] as List<dynamic>)
          .map((item) => OrderProduct.fromMap(item))
          .toList(),
      total: (data['total'] as num).toDouble(),
      status: data['status'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

class OrderProduct {
  final String productId;
  final String nombre;
  final double precio;
  final int cantidad;

  OrderProduct({
    required this.productId,
    required this.nombre,
    required this.precio,
    required this.cantidad,
  });

  factory OrderProduct.fromMap(Map<String, dynamic> data) {
    return OrderProduct(
      productId: data['productId'],
      nombre: data['nombre'],
      precio: (data['precio'] as num).toDouble(),
      cantidad: data['cantidad'],
    );
  }
}
