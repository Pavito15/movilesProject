import 'dart:io'; // Importa para manejar archivos locales
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cardProvider.dart';

class ShoppyCar extends StatelessWidget {
  const ShoppyCar({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito de Compras'),
        backgroundColor: Colors.blue,
      ),
      body: cartProvider.items.isEmpty
          ? const Center(child: Text('El carrito está vacío'))
          : ListView.builder(
              itemCount: cartProvider.items.length,
              itemBuilder: (context, index) {
                final item = cartProvider.items[index];
                return ListTile(
                  leading: item.producto.imagen.startsWith('/')
                      ? Image.file(
                          File(item.producto.imagen),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image, size: 50);
                          },
                        )
                      : Image.network(
                          item.producto.imagen,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image, size: 50);
                          },
                        ),
                  title: Text(item.producto.nombre),
                  subtitle: Text('Cantidad: ${item.cantidad}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      cartProvider.removeFromCart(item.producto);
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: cartProvider.totalItems > 0
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Implementar lógica de pago
                },
                child: Text('Pagar (\$${cartProvider.totalPrice.toStringAsFixed(2)})'),
              ),
            )
          : null,
    );
  }
}