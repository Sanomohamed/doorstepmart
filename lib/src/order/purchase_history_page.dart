import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/src/order/order_detail_page.dart' as order_detail_page;
import 'package:doorstepmart/src/order/widget/order_cart.dart';
import 'package:doorstepmart/src/order/widget/order_status_toggle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PurchaseHistoryPage extends StatefulWidget {
  const PurchaseHistoryPage({super.key,});
  //const PurchaseHistoryPage({super.key});

  @override
  State<PurchaseHistoryPage> createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  String selectedStatus = "Pending";
  final userId = FirebaseAuth.instance.currentUser?.uid;

Stream<List<Map<String, dynamic>>> fetchOrdersStream(String status) {
  if (userId == null || status.trim().isEmpty) return const Stream.empty();
  print("Fetching all orders for user"); // Debug print

  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('orders')
      .where('status', isEqualTo: status)
      .snapshots()
      .map((snapshot) {
        final orders = snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();

        // Safety: manual sort in case any timestamp issues
        orders.sort((a, b) {
          final aTime = a['timestamp'];
          final bTime = b['timestamp'];
          if (aTime is Timestamp && bTime is Timestamp) {
            return bTime.compareTo(aTime); // descending
          }
          return 0;
        });

        return orders;
      });
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color.fromARGB(222, 231, 235, 233),
    appBar: AppBar(
      title: const Text("Purchase History"),
      backgroundColor: const Color.fromARGB(255, 58, 183, 100),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          children: [
            const SizedBox(height: 10),
      // Status Toggle (Centered Layout)
            OrderStatusToggle(
              selectedStatus: selectedStatus,
              onStatusChanged: (status) {
                setState(() => selectedStatus = status);
              },
            ),

            const SizedBox(height: 10),

      // Order List
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: fetchOrdersStream(selectedStatus),
                builder: (context, snapshot) {
                  print("Snapshot connection state: ${snapshot.connectionState}");
  print("Snapshot data: ${snapshot.data}");
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
                            builder: (_) =>
                                order_detail_page.OrderDetailsPage(orderData: order),
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
      ),
    ),
  );
}
}
