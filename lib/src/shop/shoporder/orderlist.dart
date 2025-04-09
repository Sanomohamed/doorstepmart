import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/src/shop/shoporder/shop_order_card.dart';
import 'package:flutter/material.dart';
//importing the necessary packages
//for the OrderList widget, which displays a list of orders for a specific shop.

class OrderList extends StatelessWidget {
  // A widget that displays a list of orders for a specific shop.
  final String shopId;

  const OrderList({super.key, required this.shopId});

  @override
  Widget build(BuildContext context) {
    //build method to create the UI of the OrderList widget
    // It uses a StreamBuilder to listen for real-time updates from Firestore.
    return StreamBuilder<QuerySnapshot>(
      // StreamBuilder to listen for changes in the Firestore collection
      // It listens to the 'orders' collection filtered by shopId and ordered by timestamp.
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('shopId', isEqualTo: shopId)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        //builder method to create the UI based on the snapshot data
        // It checks if the snapshot has data and displays a loading indicator if not.
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final orders = snapshot.data!.docs;
        if (orders.isEmpty) {
          return const Center(child: Text('No orders yet.'));
        }

        return Center(
          // Center widget to center the content within the screen
          // This is used to center the order list on the screen.
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView.builder(
              // ListView.builder to create a scrollable list of order cards
              // It uses the orders data from the snapshot to create each card.
              padding: const EdgeInsets.all(12),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                // itemBuilder method to create each order card in the list
                // It retrieves the order data from the snapshot and creates a ShopOrderCard for each order.
                final order = orders[index].data() as Map<String, dynamic>;
                final docId = orders[index].id;
                // Extracting the document ID from the snapshot
                // This ID is used to uniquely identify each order in the Firestore collection.
                return ShopOrderCard(order: order, orderId: docId);
                // Creating a ShopOrderCard widget for each order
                // The order data and document ID are passed to the card for display.
              },
            ),
          ),
        );
      },
    );
  }
}
