import 'package:flutter/material.dart';

class OrderHeader extends StatelessWidget {

  final Map<String, dynamic> order;
 

  const OrderHeader({super.key, required this.order});
// The build method creates the UI for the OrderHeader widget. It uses the order map to display the order details.
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Customer: ${order['userName'] ?? 'Unknown User'}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 15),
        Text(
          "Payment Method: ${order['paymentMethod'] ?? 'N/A'}",
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 15),
        Text(
          "Total Amount: RM${order['totalAmount'] ?? 0}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
        ),
      ],
    );
  }
}
