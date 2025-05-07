import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/productos.dart';
import 'producto_item.dart';
import 'package:project_v1/widgets/menus/menu.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key, required this.onTabSelected});

  final Function(int) onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer(carrito: [], onTabSelected: onTabSelected),
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
                    onTabSelected(1);
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
                      onTabSelected(2);
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
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('productos').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text('No hay productos disponibles.'));
                        }

                        final productos = snapshot.data!.docs.map((doc) {
                          return Producto.fromFirestore(doc);
                        }).toList();

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: productos.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.7,
                          ),
                          itemBuilder: (context, index) {
                            final producto = productos[index];
                            return ProductoItem(producto: producto);
                          },
                        );
                      },
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