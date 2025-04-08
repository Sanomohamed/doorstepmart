import 'package:doorstepmart/src/shop/shoporder/management/order_detail.dart';
import 'package:flutter/material.dart';

class ShopOrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final String orderId;

  const ShopOrderCard({
    super.key,
    required this.order,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    final status = order['status'] ?? 'Pending';
    final userName = order['userName'] ?? 'N/A';
    final totalAmount = order['totalAmount'] ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15), // More padding between cards
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => OrderPage(orderId: orderId)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customer: $userName',
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Total Amount: RM$totalAmount',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Status: $status',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
