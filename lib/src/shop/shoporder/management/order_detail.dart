import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/src/shop/shoporder/management/order_header.dart';
import 'package:doorstepmart/src/shop/shoporder/management/order_item_list.dart';
import 'package:doorstepmart/src/shop/shoporder/management/order_status.dart';
import 'package:flutter/material.dart';
/// Importing necessary packages and files for Firebase, Firestore, and UI components

class OrderPage extends StatefulWidget {
  /// A StatefulWidget that represents the Order Page.
  /// It displays the details of a specific order and allows the user to update its status.
  final String orderId;
  /// The ID of the order to be displayed.
  /// This ID is passed as a parameter to the constructor of the OrderPage.

  const OrderPage({super.key, required this.orderId});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String currentStatus = 'Pending';
  /// The current status of the order. It is initialized to 'Pending'.
  /// This variable is used to keep track of the order status and update the UI accordingly.

  void updateOrderStatus(String newStatus) async {
    /// A method to update the order status in Firestore.
    /// It takes the new status as a parameter and updates the order document in Firestore.
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderId)
        .update({'status': newStatus});

    setState(() => currentStatus = newStatus);
  }

  @override
  Widget build(BuildContext context) {
    /// The build method creates the UI for the Order Page.
    /// It uses a FutureBuilder to asynchronously retrieve the order details from Firestore.
    return Scaffold(
      appBar: AppBar(title: const Text("Order Details"), backgroundColor: Colors.green),
      body: FutureBuilder<DocumentSnapshot>(
        /// A FutureBuilder widget to asynchronously retrieve the order details.
        /// It uses the orderId passed to the widget to fetch the order document from Firestore.
        future: FirebaseFirestore.instance.collection('orders').doc(widget.orderId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final order = snapshot.data!.data() as Map<String, dynamic>;
          final List<dynamic> items = order['orderItems'] ?? [];
          currentStatus = order['status'] ?? 'Pending';

          return Center(
            /// Center widget to center the content of the page.
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                /// Padding widget to add padding around the content.
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
                      /// OrderStatusDropdown widget to display a dropdown menu for selecting the order status.
                      /// It takes the current status and a callback function to update the status.
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
