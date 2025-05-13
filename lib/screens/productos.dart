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
  List<Producto> productosFiltrados = [];
  bool isLoading = false;
  String filtroStock = 'Todos';
  String ordenSeleccionado = 'Precio Ascendente';
  String filtroNombre = '';

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

      if (!mounted) return;

      setState(() {
        productos = productosCargados;
        productosFiltrados = productosCargados;
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

  /// Método para aplicar filtros y ordenamientos
  void _aplicarFiltros() {
    setState(() {
      productosFiltrados = productos.where((producto) {
        // Filtrar por stock
        if (filtroStock == 'Disponible' && producto.stock <= 0) return false;
        if (filtroStock == 'No Disponible' && producto.stock > 0) return false;

        // Filtrar por nombre
        if (filtroNombre.isNotEmpty &&
            !producto.nombre.toLowerCase().contains(filtroNombre.toLowerCase())) {
          return false;
        }

        return true;
      }).toList();

      // Ordenar productos
      if (ordenSeleccionado == 'Precio Ascendente') {
        productosFiltrados.sort((a, b) => a.precio.compareTo(b.precio));
      } else if (ordenSeleccionado == 'Precio Descendente') {
        productosFiltrados.sort((a, b) => b.precio.compareTo(a.precio));
      }
    });
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
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _mostrarDialogoFiltros();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchProductos,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Buscar',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        filtroNombre = value;
                        _aplicarFiltros();
                      },
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(12.0),
                      itemCount: productosFiltrados.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.7,
                      ),
                      itemBuilder: (context, index) {
                        final producto = productosFiltrados[index];
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
                                        ? Image.network(
                                            producto.imagen,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return const Icon(Icons.broken_image, size: 60);
                                            },
                                          )
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
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        producto.stock > 0 ? 'En stock' : 'Sin stock',
                                        style: TextStyle(
                                          color: producto.stock > 0 ? Colors.green : Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      ElevatedButton(
                                        onPressed: producto.stock > 0
                                            ? () {
                                                Provider.of<CartProvider>(context, listen: false)
                                                    .addToCart(producto);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        '${producto.nombre} añadido al carrito'),
                                                  ),
                                                );
                                              }
                                            : null, // Deshabilita el botón si no hay stock
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: producto.stock > 0
                                              ? Colors.blue.shade900
                                              : Colors.grey,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          producto.stock > 0 ? 'Agregar al carrito' : 'Sin stock',
                                        ),
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
                ],
              ),
      ),
    );
  }

  /// Mostrar diálogo de filtros
  void _mostrarDialogoFiltros() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filtros'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: filtroStock,
                items: const [
                  DropdownMenuItem(value: 'Todos', child: Text('Todos')),
                  DropdownMenuItem(value: 'Disponible', child: Text('Disponible')),
                  DropdownMenuItem(value: 'No Disponible', child: Text('No Disponible')),
                ],
                onChanged: (value) {
                  setState(() {
                    filtroStock = value!;
                    _aplicarFiltros();
                  });
                },
              ),
              DropdownButton<String>(
                value: ordenSeleccionado,
                items: const [
                  DropdownMenuItem(value: 'Precio Ascendente', child: Text('Precio Ascendente')),
                  DropdownMenuItem(value: 'Precio Descendente', child: Text('Precio Descendente')),
                ],
                onChanged: (value) {
                  setState(() {
                    ordenSeleccionado = value!;
                    _aplicarFiltros();
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}

