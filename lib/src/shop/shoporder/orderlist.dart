import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/src/shop/shoporder/shop_order_card.dart';
import 'package:flutter/material.dart';

class OrderList extends StatelessWidget {
  final String shopId;
  final String status; // ← new parameter

  const OrderList({
    super.key,
    required this.shopId,
    this.status = 'Pending', // ← default value
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('shopId', isEqualTo: shopId)
          .where('status', isEqualTo: status)                 // ← filter by status
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return Center(child: Text('No “$status” orders yet.'));
        }

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final data = docs[index].data()! as Map<String, dynamic>;
                final docId = docs[index].id;
                data['id'] = docId;
                return ShopOrderCard(order: data, orderId: docId);
              },
            ),
          ),
        );
      },
    );
  }
}
