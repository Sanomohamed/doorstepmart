import 'package:cloud_firestore/cloud_firestore.dart';
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

  final List<Map<String, dynamic>> statusOptions = [
    {"label": "Pending", "icon": Icons.shopping_cart},
    {"label": "Processing", "icon": Icons.local_shipping},
    {"label": "Confirmed", "icon": Icons.check_circle},
    {"label": "Canceled", "icon": Icons.cancel},
  ];

  Stream<List<Map<String, dynamic>>> fetchOrdersStream(String status) {
    if (userId == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collectionGroup('orders') // 🔄 Use collectionGroup to search all subcollections
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
          _buildStatusToggles(),
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
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OrderDetailsPage(orderData: order),
                          ),
                        );
                      },
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
                            Text(
                              order['shopName'] ?? 'Unknown Shop',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Total: RM${order['totalAmount']?.toStringAsFixed(2) ?? '0.00'}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text("Payment: ${order['paymentMethod']}"),
                            Text("Status: ${order['status']}"),
                            Text(
                              "Date: ${order['timestamp']?.toDate()?.toString().split(".").first ?? ''}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
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

  Widget _buildStatusToggles() {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 35),
        separatorBuilder: (_, __) => const SizedBox(width: 45),
        itemCount: statusOptions.length,
        itemBuilder: (context, index) {
          final status = statusOptions[index]["label"];
          final icon = statusOptions[index]["icon"] as IconData;
          final isActive = selectedStatus == status;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedStatus = status;
              });
            },
            child: Column(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor:
                      isActive ? Colors.green.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
                  child: Icon(icon, color: isActive ? Colors.green : Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isActive ? Colors.black : Colors.black54,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class OrderDetailsPage extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const OrderDetailsPage({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    final orderItems = orderData['orderItems'] as List<dynamic>? ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
        backgroundColor: const Color.fromARGB(255, 58, 183, 89),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            orderData['shopName'] ?? 'Unknown Shop',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 12),
          _infoRow("Customer", orderData['userName']),
          _infoRow("Payment", orderData['paymentMethod']),
          _infoRow("Status", orderData['status']),
          _infoRow("Total", "RM${orderData['totalAmount']?.toStringAsFixed(2)}"),
          _infoRow("Date", orderData['timestamp']?.toDate()?.toString().split(".").first ?? ''),
          const SizedBox(height: 20),
          const Text("Items", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...orderItems.map((item) => _buildItemCard(item)),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart),
                label: const Text("Reorder"),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.star),
                label: const Text("Rate Order"),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _infoRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title:", style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value ?? '-', style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(item['image'], width: 50, height: 50, fit: BoxFit.cover),
        ),
        title: Text(item['name'] ?? ''),
        subtitle: Text("RM${item['price']} x ${item['quantity']}"),
        trailing: Text("RM${(item['price'] * item['quantity']).toStringAsFixed(2)}"),
      ),
    );
  }
}
