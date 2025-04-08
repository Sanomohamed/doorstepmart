import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/src/shop/shoporder/management/order_header.dart';
import 'package:doorstepmart/src/shop/shoporder/management/order_item_list.dart';
import 'package:doorstepmart/src/shop/shoporder/management/order_status.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  final String orderId;

  const OrderPage({super.key, required this.orderId});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String currentStatus = 'Pending';

  void updateOrderStatus(String newStatus) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderId)
        .update({'status': newStatus});

    setState(() => currentStatus = newStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Details"), backgroundColor: Colors.green),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('orders').doc(widget.orderId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final order = snapshot.data!.data() as Map<String, dynamic>;
          final List<dynamic> items = order['orderItems'] ?? [];
          currentStatus = order['status'] ?? 'Pending';

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OrderHeader(order: order),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 20),
                    const Text("Order Items:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10),
                    Expanded(child: OrderItemList(items: items)),
                    const SizedBox(height: 10),
                    const Text("Order Status:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    OrderStatusDropdown(
                      currentStatus: currentStatus,
                      onChanged: updateOrderStatus,
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
