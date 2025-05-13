import 'package:flutter/material.dart';
import 'package:project_v1/screens/home_screens.dart';
import 'package:project_v1/screens/shoppy_car.dart';
import 'package:project_v1/screens/productos.dart';
import 'package:provider/provider.dart';
import 'package:project_v1/provider/card_provider.dart';

class TabsScreen extends StatefulWidget {
  final int initialIndex;
  const TabsScreen({super.key, this.initialIndex = 0});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  late int _selectedPageIndex;

  @override
  void initState() {
    super.initState();
    _selectedPageIndex = widget.initialIndex;
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(onTabSelected: _selectPage),
      const ShoppyCar(),
      const ProductosScreen(),
    ];

    Provider.of<CartProvider>(context);

    return Scaffold(
      // Elimina la propiedad `drawer` para quitar el menú hamburguesa
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