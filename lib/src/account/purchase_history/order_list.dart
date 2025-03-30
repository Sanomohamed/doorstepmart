import 'package:doorstepmart/src/account/purchase_history/purchase_history_controller.dart';
import 'package:doorstepmart/src/order/order_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderList extends StatelessWidget {
  final String selectedStatus;

  const OrderList({super.key, required this.selectedStatus});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: PurchaseHistoryController.fetchOrdersStream(selectedStatus),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No orders found."));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final order = snapshot.data![index];

            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => OrderDetailsPage(orderData: order)),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order['shopName'] ?? 'Unknown Shop', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("Total: RM${order['totalAmount']?.toStringAsFixed(2) ?? '0.00'}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text("Payment: ${order['paymentMethod']}"),
                    Text("Status: ${order['status']}"),
                    Text("Date: ${order['timestamp']?.toDate()?.toString().split(".").first ?? ''}", style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
