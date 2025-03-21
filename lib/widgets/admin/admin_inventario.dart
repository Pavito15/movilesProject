import 'dart:math';
import 'package:flutter/material.dart';
import 'package:project_v1/models/productos.dart';

class AdminInventario extends StatelessWidget {
  final List<Producto> productos;

  const AdminInventario({super.key, required this.productos});

  @override
  Widget build(BuildContext context) {
    final random = Random();

    return Scaffold(
      appBar: AppBar(
        title: Text('Inventario', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: productos.length + 1, // +1 para incluir la imagen
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              children: [
                SizedBox(height: 20),
                Image.asset(
                  'assets/imagenes_home/logocleorganic.png',
                  height: 150,
                ),
                SizedBox(height: 50),
              ],
            );
          }
          final producto = productos[index - 1]; 
          final stock = random.nextInt(100); // Genera un número aleatorio entre 0 y 99 por mientras
          final isActive = random.nextBool(); // Genera un estado aleatorio (activo o no) por mientras

          return ListTile(
            leading: Image.asset(producto.imagen, width: 50, height: 50, fit: BoxFit.cover),
            title: Text(producto.nombre),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Precio: \$${producto.precio.toStringAsFixed(2)}'),
                Text('Stock actual: $stock'), // Muestra el stock aleatorio
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isActive ? Icons.check_circle : Icons.cancel,
                  color: isActive ? Colors.green : Colors.red,
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Acción para editar el producto
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Editar Producto'),
                        content: Text('Aquí puedes implementar la lógica para editar el producto.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Cerrar'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
