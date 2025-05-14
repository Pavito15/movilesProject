import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_v1/provider/order_provider.dart';
import 'package:project_v1/widgets/menus/custom_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  late String userId;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser!.uid;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderProvider>(context, listen: false).fetchOrders();
    });
  }

  Future<int> _getUserProductRatingsCount(String productId, String orderId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('product_ratings')
        .where('userId', isEqualTo: userId)
        .where('productId', isEqualTo: productId)
        .where('orderId', isEqualTo: orderId)
        .get();
    return snapshot.docs.length;
  }

  Future<void> _rateProduct(String productId, String orderId, double rating) async {
    await FirebaseFirestore.instance.collection('product_ratings').add({
      'userId': userId,
      'productId': productId,
      'orderId': orderId,
      'rating': rating,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Actualiza el promedio y el conteo en la colección productos
    final productoRef = FirebaseFirestore.instance.collection('productos').doc(productId);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(productoRef);
      if (!snapshot.exists) return;
      final data = snapshot.data()!;
      final currentRating = data['rating'] ?? 0.0;
      final currentRatingCount = data['ratingCount'] ?? 0;
      final newRating = ((currentRating * currentRatingCount) + rating) / (currentRatingCount + 1);
      final newRatingCount = currentRatingCount + 1;
      transaction.update(productoRef, {
        'rating': newRating,
        'ratingCount': newRatingCount,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: "My Orders",
        actionWidget: const SizedBox.shrink(),
      ),
      body: orderProvider.orders.isEmpty
          ? const Center(child: Text('No tienes pedidos realizados.'))
          : ListView.builder(
              itemCount: orderProvider.orders.length,
              itemBuilder: (context, index) {
                final order = orderProvider.orders[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 6.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.blue.shade900,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Encabezado del pedido
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Pedido #${order.id.substring(0, 6)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                DateFormat('dd/MM/yyyy')
                                    .format(order.createdAt),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Lista de productos con rating
                          Column(
                            children: order.products.map((product) {
                              return FutureBuilder<int>(
                                future: _getUserProductRatingsCount(product.productId, order.id),
                                builder: (context, snapshot) {
                                  final ratingsCount = snapshot.data ?? 0;
                                  final puedeCalificar = ratingsCount < product.cantidad;
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${product.nombre} x${product.cantidad}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '\$${(product.precio * product.cantidad).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                      puedeCalificar
                                          ? IconButton(
                                              icon: const Icon(Icons.star_border, color: Colors.amber),
                                              tooltip: 'Calificar producto',
                                              onPressed: () async {
                                                double rating = 5.0;
                                                await showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                    title: Text('Califica ${product.nombre}'),
                                                    content: StatefulBuilder(
                                                      builder: (context, setState) {
                                                        return Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            RatingBar(
                                                              filledIcon: Icons.star,
                                                              emptyIcon: Icons.star_border,
                                                              onRatingChanged: (value) {
                                                                setState(() {
                                                                  rating = value;
                                                                });
                                                              },
                                                              initialRating: rating,
                                                              maxRating: 5,
                                                              filledColor: Colors.orange,
                                                              size: 32,
                                                            ),
                                                            const SizedBox(height: 10),
                                                            Text('Valor: ${rating.toStringAsFixed(1)}'),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () async {
                                                          await _rateProduct(product.productId, order.id, rating);
                                                          Navigator.pop(context);
                                                          setState(() {});
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            const SnackBar(content: Text('¡Gracias por tu calificación!')),
                                                          );
                                                        },
                                                        child: const Text('Calificar'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () => Navigator.pop(context),
                                                        child: const Text('Cancelar'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            )
                                          : const Icon(Icons.check, color: Colors.green),
                                    ],
                                  );
                                },
                              );
                            }).toList(),
                          ),
                          const Divider(color: Colors.white54),
                          // Total y estado
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total: \$${order.total.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                order.status.toUpperCase(),
                                style: TextStyle(
                                  color: order.status == 'completed'
                                      ? Colors.greenAccent
                                      : Colors.yellowAccent,
                                  fontWeight: FontWeight.bold,
                                ),
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
    );
  }
}