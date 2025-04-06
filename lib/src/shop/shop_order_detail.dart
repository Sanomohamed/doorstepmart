import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  final String orderId;

  const OrderPage({super.key, required this.orderId});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String currentStatus = 'Pending';

  void updateOrderStatus(String orderId, String newStatus) async {
    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'status': newStatus,
    });

    setState(() {
      currentStatus = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Details"), backgroundColor: Colors.green),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('orders').doc(widget.orderId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final order = snapshot.data!.data() as Map<String, dynamic>;
          final List<dynamic> items = order['orderItems'] ?? [];
          currentStatus = order['status'] ?? 'Pending';

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Customer: ${order['userName'] ?? 'Unknown User'}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text("Payment Method: ${order['paymentMethod'] ?? 'N/A'}"),
                    Text("Total Amount: RM${order['totalAmount'] ?? 0}",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Divider(),

                    const Text("Order Items:",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 6),

                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];

                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item['image'] ?? '',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.image_not_supported),
                                ),
                              ),
                              title: Text(item['name'] ?? 'Unknown Item'),
                              subtitle: Text(
                                  'RM${item['price'] ?? 0} x ${item['quantity'] ?? 1}'),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 10),
                    const Text("Order Status:",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    DropdownButton<String>(
                      value: currentStatus,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                        DropdownMenuItem(value: 'Processing', child: Text('Processing')),
                        DropdownMenuItem(value: 'Confirmed', child: Text('Confirmed')),
                        DropdownMenuItem(value: 'Cancelled', child: Text('Cancelled')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          updateOrderStatus(widget.orderId, value);
                        }
                      },
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
