import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_v1/widgets/admin/admin_widget.dart'; // Importa Admin Panel
import 'package:project_v1/screens/home_screens.dart'; // Importa Home
import 'package:project_v1/screens/tabs.dart'; // Ensure TabsScreen is imported

class AdminInventario extends StatefulWidget {
  const AdminInventario({super.key});

  @override
  _AdminInventarioState createState() => _AdminInventarioState();
}

class _AdminInventarioState extends State<AdminInventario> {
  int _selectedIndex = 1;
  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TabsScreen(initialIndex: 0)),
      );
    } else if (index == 1) {
      // Mantente en la pantalla actual
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminWidget()),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('productos').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay productos disponibles.'));
          }

          final productos = snapshot.data!.docs;

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, index) {
              final producto = productos[index].data() as Map<String, dynamic>;
              final id = productos[index].id;

              return ListTile(
                title: Text(producto['nombre']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Precio: \$${producto['precio']}'),
                    Row(
                      children: [
                        Text('Stock disponible: ${producto['stock']}'),
                        const SizedBox(width: 8),
                        Icon(
                          producto['stock'] > 0 ? Icons.check_circle : Icons.cancel,
                          color: producto['stock'] > 0 ? Colors.green : Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Botón de Editar
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            final nombreController = TextEditingController(text: producto['nombre']);
                            final precioController = TextEditingController(text: producto['precio'].toString());
                            final descripcionController = TextEditingController(text: producto['descripcion']);
                            final stockController = TextEditingController(text: producto['stock'].toString());

                            return AlertDialog(
                              title: const Text('Editar Producto'),
                              content: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: nombreController,
                                      decoration: const InputDecoration(labelText: 'Nombre'),
                                    ),
                                    TextField(
                                      controller: precioController,
                                      decoration: const InputDecoration(labelText: 'Precio'),
                                      keyboardType: TextInputType.number,
                                    ),
                                    TextField(
                                      controller: descripcionController,
                                      decoration: const InputDecoration(labelText: 'Descripción'),
                                      maxLines: 3,
                                    ),
                                    TextField(
                                      controller: stockController,
                                      decoration: const InputDecoration(labelText: 'Stock'),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance.collection('productos').doc(id).update({
                                      'nombre': nombreController.text,
                                      'precio': double.parse(precioController.text),
                                      'descripcion': descripcionController.text,
                                      'stock': int.parse(stockController.text),
                                    });

                                    // Verificar si el widget sigue montado
                                    if (!mounted) return;

                                    // Navegar hacia atrás si el contexto sigue montado
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Producto actualizado exitosamente')),
                                      );
                                    }
                                  },
                                  child: const Text('Guardar'),
                                ),

                              ],
                            );
                          },
                        );
                      },
                    ),
                    // Botón de Eliminar
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Confirmar eliminación'),
                              content: const Text('¿Estás seguro de que deseas eliminar este producto?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: const Text('Eliminar'),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirm == true) {
                          await FirebaseFirestore.instance.collection('productos').doc(id).delete();
                          
                          // Verificar si el widget sigue montado
                          if (!mounted) return;
                          
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Producto eliminado exitosamente')),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Inventario'),
          BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings), label: 'Admin Panel'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}