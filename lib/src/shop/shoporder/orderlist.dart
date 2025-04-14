import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/src/shop/shoporder/shop_order_card.dart';    //importing the necessary packages
import 'package:flutter/material.dart';

class OrderList extends StatelessWidget {
 
  final String shopId;

  const OrderList({super.key, required this.shopId});
//build method to create the UI of the OrderList widget, It uses a StreamBuilder to listen for real-time updates from Firestore.
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('shopId', isEqualTo: shopId)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) { //builder method to create the UI based on the snapshot data
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final orders = snapshot.data!.docs;
        if (orders.isEmpty) {
          return const Center(child: Text('No orders yet.'));
        }

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView.builder( // ListView.builder to create a scrollable list of order cards
              padding: const EdgeInsets.all(12),
              itemCount: orders.length,
              itemBuilder: (context, index) {  // itemBuilder method to create each order card in the list
                final order = orders[index].data() as Map<String, dynamic>;
                final docId = orders[index].id;
                return ShopOrderCard(order: order, orderId: docId);
              },
            ),
          ),
        );
      },
    );
  }
}
