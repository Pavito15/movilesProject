import 'package:flutter/material.dart';
import 'package:project_v1/screens/productos.dart';
import 'package:project_v1/screens/shoppyCar.dart';
import '../data/productos.dart';
import 'producto_item.dart';
import '../widgets/menu.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(carrito: [],),
      body: Column(
        children: [
          Container(
            color: Colors.blue[800],
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: const Center(
              child: Text(
                'Envíos gratis a toda la república a partir de \$800 ;)',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
          PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: AppBar(
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              title: const Text(
                'CLEORGANIC',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.person_outline),
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ShoppyCar(carrito: [],)),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Image.asset('assets/imagenes_home/home1.jpg'),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      '¡Los ingredientes que tu piel necesita!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProductosScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                    child: const Text(
                      'Ver productos',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ProductosList(productos: dataProductos),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}