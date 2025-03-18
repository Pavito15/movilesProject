import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            leading: Image.asset('assets/iconoproducto.png', width: 30, height: 30),
            title: Text('Productos'),
            onTap: () {
              // Navegar a la pantalla de productos
              Navigator.pushNamed(context, '/productos');
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart, size: 30),
            title: Text('Carrito'),
            onTap: () {
              // Navegar a la pantalla del carrito
              Navigator.pushNamed(context, '/carrito');
            },
          ),
        ],
      ),
    );
  }
}