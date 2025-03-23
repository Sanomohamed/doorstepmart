import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShopOrderManagementPage extends StatelessWidget {
  const ShopOrderManagementPage({super.key});

  Future<String?> getShopId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final snapshot = await FirebaseFirestore.instance
        .collection('shops')
        .where('userId', isEqualTo: user.uid)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.id;
    }
    return null;
  }

  void updateOrderStatus(String orderId, String newStatus) async {
    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'status': newStatus,
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getShopId(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final shopId = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Shop Order Management'),
            backgroundColor: Colors.green,
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .where('shopId', isEqualTo: shopId)
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final orders = snapshot.data!.docs;
              if (orders.isEmpty) {
                return const Center(child: Text('No orders yet.'));
              }

              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index].data() as Map<String, dynamic>;
                  final docId = orders[index].id;
                  final status = order['status'] ?? 'Pending';

                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text('Customer: ${order['userName'] ?? 'N/A'}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total: RM${order['totalAmount'] ?? 0}'),
                          Text('Payment: ${order['paymentMethod'] ?? ''}'),
                          Text('Status: $status'),
                          const SizedBox(height: 10),
                          DropdownButton<String>(
                            value: status,
                            items: const [
                              DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                              DropdownMenuItem(value: 'Processing', child: Text('Processing')),
                              DropdownMenuItem(value: 'Confirmed', child: Text('Confirmed')),
                              DropdownMenuItem(value: 'Cancelled', child: Text('Cancelled')),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                updateOrderStatus(docId, value);
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
