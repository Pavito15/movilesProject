import 'dart:io'; // Importa para manejar archivos locales
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/productos.dart';
import '../provider/cardProvider.dart';
import '../screens/producto_details.dart';

class ProductoItem extends StatelessWidget {
  const ProductoItem({super.key, required this.producto});

  final Producto producto;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalleProductoScreen(producto: producto),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.blue[900],
        child: Container(
          width: 200,
          height: 300,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Mostrar la imagen del producto
              Expanded(
                child: producto.imagen.startsWith('/')
                    ? Image.file(
                        File(producto.imagen),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image, size: 60, color: Colors.white);
                        },
                      )
                    : Image.network(
                        producto.imagen,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image, size: 60, color: Colors.white);
                        },
                      ),
              ),
              const SizedBox(height: 10),
              Text(
                producto.nombre,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                '\$${producto.precio.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              FloatingActionButton(
                onPressed: () {
                  // Agregar el producto al carrito
                  Provider.of<CartProvider>(context, listen: false).addToCart(producto);

                  // Mostrar un mensaje de confirmación
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${producto.nombre} añadido al carrito'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                mini: true,
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.add_shopping_cart,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}