import 'package:flutter/material.dart';
import 'package:project_v1/screens/home_screens.dart';
import 'package:project_v1/screens/shoppyCar.dart';
import 'package:project_v1/screens/productos.dart';
import 'package:project_v1/models/productos.dart';
import 'package:project_v1/widgets/menus/menu.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Producto> carrito = [];

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(onTabSelected: _selectPage),
      ShoppyCar(carrito: carrito),
      ProductosScreen(onProductSelected: (producto) {}),
    ];

    return Scaffold(
      drawer: MenuDrawer(carrito: carrito, onTabSelected: _selectPage),
      body: IndexedStack(
        index: _selectedPageIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        selectedItemColor: Colors.blue.shade900,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Carrito'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Productos'),
        ],
      ),
    );
  }
}