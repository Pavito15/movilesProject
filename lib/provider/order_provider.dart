import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_v1/models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  List<UserOrder> _orders = [];

  List<UserOrder> get orders => _orders;

  Future<void> fetchOrders() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      debugPrint('Fetching orders for user: ${user.uid}');

      final snapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .get();

      debugPrint('Found ${snapshot.docs.length} orders');

      if (snapshot.docs.isEmpty) {
        debugPrint('No orders found for user ${user.uid}');
        notifyListeners();
        return;
      }

      _orders = snapshot.docs
          .map((doc) {
            debugPrint('Processing order: ${doc.id}');
            try {
              return UserOrder.fromFirestore(doc.data(), doc.id);
            } catch (e) {
              debugPrint('Error mapping order ${doc.id}: $e');
              return null;
            }
          })
          .whereType<UserOrder>()
          .toList();

      debugPrint('Mapped ${_orders.length} orders successfully');
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching orders: $e');
    }
  }
}
