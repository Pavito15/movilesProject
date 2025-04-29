import 'package:flutter/material.dart';
import 'package:project_v1/models/productos.dart';

class MenuDrawer extends StatelessWidget {
  final List<Producto> carrito;
  final void Function(int index) onTabSelected;

  const MenuDrawer({super.key, required this.carrito, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Encabezado del menú con solo el recuadro azul y texto
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue.shade800,
            ),
            child: Center(
              child: const Text(
                "CLEORGANIC",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Opciones del menú
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.person, size: 30, color: Colors.blue),
                  title: const Text('Perfil'),
                  onTap: () {
                    Navigator.pop(context); // Cierra el menú
                    Navigator.pushNamed(context, '/profile'); // Redirige a la pantalla de inicio de sesión
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.category, size: 30, color: Colors.blue),
                  title: const Text('Productos'),
                  onTap: () {
                    Navigator.pop(context); // Cierra el menú
                    onTabSelected(2); // Redirige a la sección de productos
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.shopping_cart, size: 30, color: Colors.blue),
                  title: const Text('Carrito'),
                  onTap: () {
                    Navigator.pop(context); // Cierra el menú
                    onTabSelected(1); // Redirige al carrito
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}