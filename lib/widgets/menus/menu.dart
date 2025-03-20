import 'package:flutter/material.dart';
import 'package:project_v1/models/productos.dart';
import 'package:project_v1/screens/productos.dart';
import 'package:project_v1/screens/shoppyCar.dart';


class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key, required this.carrito});

  final List<Producto> carrito;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            leading: Image.asset('assets/iconoproducto.png', width: 30, height: 30),
            title: const Text('Productos'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductosScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart, size: 30),
            title: const Text('Carrito'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShoppyCar(carrito: carrito)),
              );
            },
          ),
        ],
      ),
    );
  }
}
