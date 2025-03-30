import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/src/account/purchase_history.dart';
import 'package:doorstepmart/src/account/purchase_history/order_detail_page.dart' as order_detail_page;
import 'package:doorstepmart/src/order/widget/order_cart.dart';
import 'package:doorstepmart/src/order/widget/order_status_toggle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PurchaseHistoryPage extends StatefulWidget {
  const PurchaseHistoryPage({super.key});

  @override
  State<PurchaseHistoryPage> createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  String selectedStatus = "Pending";
  final userId = FirebaseAuth.instance.currentUser?.uid;

  Stream<List<Map<String, dynamic>>> fetchOrdersStream(String status) {
    if (userId == null) return const Stream.empty();
    return FirebaseFirestore.instance
        .collectionGroup('orders')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: status)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return data;
            }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF),
      appBar: AppBar(
        title: const Text("Purchase History"),
        backgroundColor: const Color.fromARGB(255, 58, 183, 100),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          OrderStatusToggle(
            selectedStatus: selectedStatus,
            onStatusChanged: (status) {
              setState(() => selectedStatus = status);
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: fetchOrdersStream(selectedStatus),
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
                    return OrderCard(
                      order: order,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => order_detail_page.OrderDetailsPage(orderData: order),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
