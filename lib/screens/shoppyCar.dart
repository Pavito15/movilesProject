import 'package:flutter/material.dart';
import '../models/productos.dart';

class ShoppyCar extends StatefulWidget {
  const ShoppyCar({super.key, required List<Producto> carrito});

  @override
  _ShoppyCarState createState() => _ShoppyCarState();
}

class _ShoppyCarState extends State<ShoppyCar> {
  final List<Producto> productos = [
    Producto(
      id: 1,
      nombre: 'Vitamina C hidra Glow Serum',
      precio: 315.0,
      imagen: 'assets/imagenes_productos/1.jpg',
      descripcion: 'Serum de vitamina C 10% con ácido hialurónico.',
    ),
    Producto(
      id: 2,
      nombre: 'Niacinamida Serum',
      precio: 280.0,
      imagen: 'assets/imagenes_productos/2.jpg',
      descripcion: 'Serum de niacinamida al 5% con centella asiática.',
    ),
    Producto(
      id: 3,
      nombre: 'Ácido hialurónico Hidra Serum',
      precio: 280.0,
      imagen: 'assets/imagenes_productos/3.jpg',
      descripcion: 'Hidratación profunda con extracto de pepino.',
    ),
  ];

  final Map<int, int> cantidades = {};

  @override
  void initState() {
    super.initState();
    for (var producto in productos) {
      cantidades[producto.id] = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CLEORGANIC',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Carrito de compras',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            
            Expanded(
              child: ListView.builder(
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  final producto = productos[index];
                  return Card(
                    color: Colors.blue.shade900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              producto.imagen,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  producto.nombre,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '30 ml',
                                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${producto.precio.toInt()}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.add_circle, color: Colors.white, size: 30),
                                onPressed: () {
                                  setState(() {
                                    cantidades[producto.id] = cantidades[producto.id]! + 1;
                                  });
                                },
                              ),
                              Text(
                                cantidades[producto.id].toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.white, size: 30),
                                onPressed: () {
                                  setState(() {
                                    productos.removeAt(index);
                                  });
                                },
                              ),
                            ],
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
}
