import 'package:cloud_firestore/cloud_firestore.dart';

class Producto {
  final String id;
  final String nombre;
  final double precio;
  final String imagen;
  final String descripcion;
  final int stock;
  final double rating;
  final int ratingCount;

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.imagen,
    required this.descripcion,
    required this.stock,
    required this.rating,
    required this.ratingCount,
  });

  factory Producto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Producto(
      id: doc.id,
      nombre: data['nombre'],
      precio: data['precio'],
      imagen: data['imagen'],
      descripcion: data['descripcion'],
      stock: data['stock'],
      rating: data['rating'] ?? 0.0,
      ratingCount: data['ratingCount'] ?? 0,
    );
  }

  /// Método para verificar si el producto está disponible
  bool get estaDisponible => stock > 0;

  Map<String, dynamic> toFirestore() {
    return {
      'nombre': nombre,
      'precio': precio,
      'imagen': imagen,
      'descripcion': descripcion,
      'stock': stock,
      'rating': rating,
      'ratingCount': ratingCount,
    };
  }
}