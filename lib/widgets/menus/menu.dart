import 'package:flutter/material.dart';
import 'package:project_v1/models/productos.dart';

class MenuDrawer extends StatelessWidget {
  final List<Producto> carrito;
  final void Function(int index) onTabSelected;

  const MenuDrawer({super.key, required this.carrito, required this.onTabSelected});

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
              Navigator.pop(context); 
              onTabSelected(2); 
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart, size: 30),
            title: const Text('Carrito'),
            onTap: () {
              Navigator.pop(context); 
              onTabSelected(1); 
            },
          ),
        ],
      ),
    );
  }
}
