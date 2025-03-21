import 'package:flutter/material.dart';
import '../models/productos.dart';
import '../screens/Payment/pay.dart';

class ShoppyCar extends StatefulWidget {
  const ShoppyCar({super.key, required this.carrito});

  final List<Producto> carrito;

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

  double calcularTotal() {
    double total = 0.0;
    for (var producto in productos) {
      total += producto.precio * cantidades[producto.id]!;
    }
    return total;
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

            // Total de compra
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total:",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("\$${calcularTotal().toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Botón para proceder al pago
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(totalCompra: calcularTotal()),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Proceder al pago',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
