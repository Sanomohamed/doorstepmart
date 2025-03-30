import 'package:doorstepmart/src/account/purchase_history/order_item_card.dart';
import 'package:flutter/material.dart';

class OrderDetailsPage extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const OrderDetailsPage({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    final orderItems = orderData['orderItems'] as List<dynamic>? ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text("Order Details"), backgroundColor: Colors.green),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(orderData['shopName'] ?? 'Unknown Shop', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
          const SizedBox(height: 12),
          ...orderItems.map((item) => OrderItemCard(item: item)).toList(),
        ],
      ),
    );
  }
}
