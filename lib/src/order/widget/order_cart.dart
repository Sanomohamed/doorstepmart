import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback onTap;

  const OrderCard({super.key, required this.order,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Shop Name: ${order['shopName'] ?? 'Unknown Shop'}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),    
            Text("Total: RM${order['totalAmount']?.toStringAsFixed(2) ?? '0.00'}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text("Payment: ${order['paymentMethod']}"),
            Text("Status: ${order['status']}"),
            Text("Date: ${order['timestamp']?.toDate()?.toString().split(".").first ?? ''}",
                style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 6),
            Text("Order ID: ${order['id']}", // Display the orderRef.id
                style: const TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
