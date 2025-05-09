import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/productos.dart';
import '../provider/card_provider.dart';
import '../screens/producto_details.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';

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
      child: SizedBox(
        width: 180,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.blue.shade900,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Imagen del producto
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: producto.imagen.startsWith('/')
                      ? Image.file(
                          File(producto.imagen),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image, size: 60, color: Colors.grey);
                          },
                        )
                      : Image.network(
                          producto.imagen,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image, size: 60, color: Colors.grey);
                          },
                        ),
                ),
                const SizedBox(height: 10),
                // Nombre del producto
                Text(
                  producto.nombre,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                // Precio del producto
                Text(
                  '\$${producto.precio.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                // Mostrar el rating promedio
                RatingBar.readOnly(
                  filledIcon: Icons.star,
                  emptyIcon: Icons.star_border,
                  initialRating: producto.rating,
                  maxRating: 5,
                  filledColor: Colors.orange,
                  size: 14,
                ),
                const SizedBox(height: 8),
                // Icono para agregar al carrito
                Container(
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    iconSize: 20,
                    icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
                    onPressed: () {
                      Provider.of<CartProvider>(context, listen: false).addToCart(producto);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${producto.nombre} añadido al carrito'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
