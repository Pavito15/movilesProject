import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_v1/widgets/admin/admin_widget.dart'; // Importa Admin Panel
import 'package:project_v1/screens/home_screens.dart'; // Importa Home

class AdminAddProducto extends StatefulWidget {
  const AdminAddProducto({super.key});

  @override
  _AdminAddProductoState createState() => _AdminAddProductoState();
}

class _AdminAddProductoState extends State<AdminAddProducto> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  String? _imageUrl;
  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      try {
        final directory = await getApplicationDocumentsDirectory();
        final localPath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        final localFile = await _imageFile!.copy(localPath);

        setState(() {
          _imageUrl = localFile.path;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Imagen guardada localmente')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar la imagen localmente: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se seleccionó ninguna imagen')),
      );
    }
  }

  Future<void> _guardarProducto() async {
    if (_formKey.currentState!.validate() && _imageUrl != null) {
      final nuevoProducto = {
        'nombre': _nombreController.text,
        'precio': double.parse(_precioController.text),
        'imagen': _imageUrl,
        'descripcion': _descripcionController.text,
        'stock': int.parse(_stockController.text),
        'fechaCreacion': FieldValue.serverTimestamp(),
      };

      try {
        await FirebaseFirestore.instance.collection('productos').add(nuevoProducto);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Producto "${_nombreController.text}" agregado exitosamente')),
        );

        _nombreController.clear();
        _precioController.clear();
        _descripcionController.clear();
        _stockController.clear();
        setState(() {
          _imageFile = null;
          _imageUrl = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar el producto: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona una imagen')),
      );
    }
  }

  int _selectedIndex = 1; // Índice inicial para AdminAddProducto

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(onTabSelected: (int) {  },)), // Navega a Home
      );
    } else if (index == 1) {
      // Mantente en la pantalla actual
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminWidget()), // Navega al Admin Panel
      );
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
                    child: _imageFile == null
                        ? const Text('No se ha seleccionado ninguna imagen')
                        : Image.file(_imageFile!, height: 100),
                  ),
                  IconButton(
                    icon: const Icon(Icons.image),
                    onPressed: _pickImage,
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
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Agregar Producto'),
          BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings), label: 'Admin Panel'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}