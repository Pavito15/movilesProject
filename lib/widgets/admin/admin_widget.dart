import 'package:flutter/material.dart';
import 'package:project_v1/widgets/admin/admin_add.dart';
import 'package:project_v1/widgets/admin/admin_inventario.dart';

import '../../data/productos.dart'; 

class AdminWidget extends StatelessWidget {
  const AdminWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel', style: TextStyle(color: Colors.black)), // Cambia el color del texto si es necesario
        backgroundColor: Colors.white, // Fondo blanco
        iconTheme: IconThemeData(color: Colors.black), // Cambia el color de los íconos si es necesario
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, 
          children: [
            SizedBox(height: 50), 
            Image.asset(
              'assets/imagenes_home/logocleorganic.png', 
              height: 150, 
            ),
            SizedBox(height: 50), 
            SizedBox(
              width: 300, 
              height: 70, 
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminAddProducto()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, 
                ),
                child: Text(
                  'Agregar Productos Nuevos',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15, 
                  ), 
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 300, 
              height: 70, 
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminInventario(
                        productos: dataProductos, // Pasa la lista de productos
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, 
                ),
                child: Text(
                  'Ver Inventario',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15, 
                  ), 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
