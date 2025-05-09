import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import '../models/productos.dart';
import '../provider/card_provider.dart';
import 'package:provider/provider.dart';
import 'producto_details.dart';

class ProductosScreen extends StatefulWidget {
  const ProductosScreen({super.key});

  @override
  _ProductosScreenState createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  List<Producto> productos = [];
  bool isLoading = false;

  /// Método para obtener los productos desde Firebase
  Future<void> _fetchProductos() async {
    setState(() {
      isLoading = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance.collection('productos').get();
      final productosCargados = snapshot.docs.map((doc) {
        return Producto.fromFirestore(doc);
      }).toList();
      // Verifica si el widget está montado antes de llamar a setState
      // Esto es importante para evitar errores si el widget se destruye antes de que la llamada a Firebase termine
      if (!mounted) return;

      setState(() {
        productos = productosCargados;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar productos: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProductos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchProductos, // Refresca los datos al hacer swipe
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                padding: const EdgeInsets.all(12.0),
                itemCount: productos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final producto = productos[index];
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
                        side: const BorderSide(color: Colors.blueAccent, width: 1),
                      ),
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: producto.imagen.isNotEmpty
                                  ? (producto.imagen.startsWith('/')
                                      ? Image.file(
                                          File(producto.imagen),
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Icon(Icons.broken_image, size: 60);
                                          },
                                        )
                                      : Image.network(
                                          producto.imagen,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Icon(Icons.broken_image, size: 60);
                                          },
                                        ))
                                  : const Icon(Icons.image_not_supported, size: 60),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  producto.nombre,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${producto.precio.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    Provider.of<CartProvider>(context, listen: false)
                                        .addToCart(producto);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${producto.nombre} añadido al carrito'),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade900,
                                    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text('Agregar al carrito'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
