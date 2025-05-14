import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/card_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:http/http.dart' as http;
import 'package:project_v1/screens/login/signin.dart'; // 👈 Asegúrate de importar Signin

class ShoppyCar extends StatelessWidget {
  const ShoppyCar({super.key});

  Future<void> _payWithStripe(BuildContext context, double total,
      List cartItems, CartProvider cartProvider) async {
    try {
      final amount = (total * 100).toInt();

      final response = await http.post(
        Uri.parse('http://192.168.100.46:3000/create-payment-intent'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': amount,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Error al crear PaymentIntent: ${response.body}');
      }

      final jsonResponse = jsonDecode(response.body);
      final clientSecret = jsonResponse['clientSecret'];

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'SchoolDorx Shop',
          style: ThemeMode.light,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      final userId = FirebaseAuth.instance.currentUser!.uid;
      final products = cartItems
          .map((item) => {
                'productId': item.producto.id,
                'nombre': item.producto.nombre,
                'precio': item.producto.precio,
                'cantidad': item.cantidad,
              })
          .toList();

      await FirebaseFirestore.instance.collection('orders').add({
        'userId': userId,
        'products': products,
        'total': total,
        'status': 'paid',
        'paymentMethod': 'stripe',
        'createdAt': FieldValue.serverTimestamp(),
      });

      cartProvider.clearCart();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('¡Pago exitoso! Su orden ha sido procesada')),
      );
    } on StripeException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de pago: ${e.error.localizedMessage}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

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
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.blue.shade900,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          item.producto.imagen.startsWith('/')
                              ? Image.file(
                                  File(item.producto.imagen),
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  item.producto.imagen,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.producto.nombre,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${item.producto.precio.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove,
                                    color: Colors.white),
                                onPressed: () {
                                  cartProvider.removeFromCart(item.producto);
                                },
                              ),
                              Text(
                                '${item.cantidad}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.add, color: Colors.white),
                                onPressed: () {
                                  cartProvider.addToCart(item.producto);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.white),
                                onPressed: () {
                                  cartProvider.removeFromCart(item.producto);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: cartProvider.totalItems > 0
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "\$${cartProvider.totalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (cartProvider.items.isNotEmpty) {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user == null) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const Signin()),
                            (Route<dynamic> route) => false,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Inicia sesión para procesar el pago')),
                          );
                          return;
                        }

                        await _payWithStripe(context, cartProvider.totalPrice,
                            cartProvider.items, cartProvider);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Confirmar compra',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            )
          : null,
    );
  }
}
