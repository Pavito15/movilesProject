import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/productos.dart';
import 'producto_item.dart';
import 'package:project_v1/widgets/menus/menu.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key, required this.onTabSelected});

  final Function(int) onTabSelected;

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  List<Producto> productos = [];
  bool isLoading = false;

  Future<void> _fetchProductos() async {
    setState(() {
      isLoading = true;
    });

    final snapshot = await FirebaseFirestore.instance.collection('productos').get();
    final productosCargados = snapshot.docs.map((doc) {
      return Producto.fromFirestore(doc);
    }).toList();

    setState(() {
      productos = productosCargados;
      isLoading = false;
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
      drawer: MenuDrawer(carrito: [], onTabSelected: widget.onTabSelected),
      // RefeshIndicator para permitir la actualización de la lista al arrastrar hacia abajo
      body: RefreshIndicator(
        onRefresh: _fetchProductos,
        child: ListView(
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
                      widget.onTabSelected(1);
                    },
                  ),
                ],
              ),
            ),
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
                widget.onTabSelected(2);
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
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: productos.map((producto) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: ProductoItem(producto: producto),
                          );
                        }).toList(),
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
