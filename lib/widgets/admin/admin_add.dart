import 'package:flutter/material.dart';
import 'package:project_v1/models/productos.dart';

class AdminAddProducto extends StatefulWidget {
  const AdminAddProducto({super.key});

  @override
  _AdminAddProductoState createState() => _AdminAddProductoState();
}

class _AdminAddProductoState extends State<AdminAddProducto> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _imagenController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  void _guardarProducto() {
    if (_formKey.currentState!.validate()) {
      final nuevoProducto = Producto(
        id: DateTime.now().millisecondsSinceEpoch,
        nombre: _nombreController.text,
        precio: double.parse(_precioController.text),
        imagen: _imagenController.text,
        descripcion: _descripcionController.text,
        stock: int.parse(_stockController.text), // Asegúrate de que el modelo Producto tenga este campo
      );

      // Aquí puedes manejar el nuevo producto, como enviarlo a una base de datos o lista
      print('Producto agregado: ${nuevoProducto.nombre}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto agregado exitosamente')),
      );

      // Limpiar los campos
      _nombreController.clear();
      _precioController.clear();
      _imagenController.clear();
      _descripcionController.clear();
      _stockController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text('Agregar Producto', style: TextStyle(color: Colors.black)),
      backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 19),
              Image.asset(
                'assets/imagenes_home/logocleorganic.png',
                height: 150,
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre del producto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _precioController,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el precio del producto';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor ingresa un número válido';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _imagenController,
                      decoration: const InputDecoration(labelText: 'URL de la Imagen'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa la URL de la imagen';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.image),
                    onPressed: () {
                      // cargar una imagen desde la galería
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cargar imagen desde la galería')),
                      );
                    },
                  ),
                ],
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una descripción';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el stock del producto';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor ingresa un número entero válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _guardarProducto,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.black,
                    fixedSize: const Size(300, 70),
                    textStyle: const TextStyle(fontSize: 15),
                  ),
                  child: const Text('Guardar Producto'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
