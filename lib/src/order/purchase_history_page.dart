// purchase_history_page.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/src/order/order_detail_page.dart' as order_detail_page;
import 'package:doorstepmart/src/order/widget/order_cart.dart';
import 'package:doorstepmart/src/order/widget/order_status_toggle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PurchaseHistoryPage extends StatefulWidget {
  /// The status to show initially (e.g. "Pending", "Processing", "Completed", "Canceled")
  final String initialStatus;
  const PurchaseHistoryPage({
    super.key,
    this.initialStatus = 'Pending',
  });

  @override
  State<PurchaseHistoryPage> createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  late String selectedStatus;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.initialStatus;
  }

  Stream<List<Map<String, dynamic>>> fetchOrdersStream(String status) {
    if (userId == null || status.isEmpty) {
      return const Stream.empty();
    }
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('orders')
        .where('status', isEqualTo: status)
        .orderBy('timestamp', descending: true)
        .snapshots(includeMetadataChanges: true)
        .map((snap) => snap.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return data;
            }).toList());
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
                  builder: (ctx, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text(
                        "Error loading orders:\n${snapshot.error}",
                        textAlign: TextAlign.center,
                      ));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final orders = snapshot.data!;
                    if (orders.isEmpty) {
                      return const Center(child: Text("No orders found."));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: orders.length,
                      itemBuilder: (ctx, i) {
                        final order = orders[i];
                        return OrderCard(
                          order: order,
                          onTap: () async {
                            final changed = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => order_detail_page
                                  .OrderDetailsPage(orderData: order),
                              ),
                            );
                            if (changed == true) setState(() {});
                          },
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
