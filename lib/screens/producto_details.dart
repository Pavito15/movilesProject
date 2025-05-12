import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project_v1/screens/tabs.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/productos.dart';
import '../provider/card_provider.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';

class DetalleProductoScreen extends StatefulWidget {
  const DetalleProductoScreen({super.key, required this.producto});

  final Producto producto;

  @override
  DetalleProductoScreenState createState() => DetalleProductoScreenState();
}

class DetalleProductoScreenState extends State<DetalleProductoScreen> {
  int cantidad = 1;
  double userRating = 0.0;
  final int _selectedPageIndex = 2;

  void _selectPage(int index) {
    if (index == _selectedPageIndex) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TabsScreen()),
    );
  }

  Future<void> _submitRating() async {
    final productoRef = FirebaseFirestore.instance.collection('productos').doc(widget.producto.id);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(productoRef);
        if (!snapshot.exists) return;

        final data = snapshot.data()!;
        final currentRating = data['rating'] ?? 0.0;
        final currentRatingCount = data['ratingCount'] ?? 0;

        final newRating = ((currentRating * currentRatingCount) + userRating) / (currentRatingCount + 1);
        final newRatingCount = currentRatingCount + 1;

        transaction.update(productoRef, {
          'rating': newRating,
          'ratingCount': newRatingCount,
        });
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gracias por calificar el producto')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al calificar el producto: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.producto.nombre, style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Imagen proporcional y centrada con borde azul
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[200],
                border: Border.all(
                  color: Colors.blue.shade900, // Borde azul
                  width: 2, // Grosor del borde
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: widget.producto.imagen.startsWith('/')
                  ? Image.file(
                      File(widget.producto.imagen),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 60);
                      },
                    )
                  : Image.network(
                      widget.producto.imagen,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 60);
                      },
                    ),
            ),
            const SizedBox(height: 20),

            // Contenedor de información y acciones
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre del producto
                  Text(
                    widget.producto.nombre,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Precio y cantidad
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Precio
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade900,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '\$${widget.producto.precio.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),

                      // Selector de cantidad
                      Column(
                        children: [
                          const Text(
                            'Cantidad',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Botón de restar
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade900,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (cantidad > 1) cantidad--;
                                    });
                                  },
                                  icon: const Icon(Icons.remove),
                                  color: Colors.white,
                                  iconSize: 20,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                              // Cuadro azul que muestra la cantidad
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade900,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  cantidad.toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // Botón de sumar
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade900,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      cantidad++;
                                    });
                                  },
                                  icon: const Icon(Icons.add),
                                  color: Colors.white,
                                  iconSize: 20,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Botón añadir al carrito
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        for (int i = 0; i < cantidad; i++) {
                          cartProvider.addToCart(widget.producto);
                        }
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Producto agregado'),
                              content: const Text('Se agregó al carrito correctamente.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 80),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Añadir a carrito',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Descripción
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Descripción',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.producto.descripcion,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            // Rating promedio
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Calificación promedio',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            RatingBar.readOnly(
              filledIcon: Icons.star,
              emptyIcon: Icons.star_border,
              initialRating: widget.producto.rating,
              maxRating: 5,
              filledColor: Colors.orange,
              size: 30,
            ),
            const SizedBox(height: 20),

            // Calificación del usuario
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Califica este producto',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            RatingBar(
              filledIcon: Icons.star,
              emptyIcon: Icons.star_border,
              onRatingChanged: (rating) {
                setState(() {
                  userRating = rating;
                });
              },
              initialRating: 0,
              maxRating: 5,
              filledColor: Colors.orange,
              size: 30,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitRating,
              child: const Text('Enviar Calificación'),
            ),
          ],
        ),
      ),
    );
  }
}