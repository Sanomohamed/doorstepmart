import 'package:flutter/material.dart';
//importing necessary packages for the OrderHeader widget

class OrderHeader extends StatelessWidget {
  // Defining the OrderHeader widget which is a StatelessWidget
  final Map<String, dynamic> order;
  // A map to hold the order details, which is passed as a parameter to the constructor
  // The map contains various details about the order such as user name, payment method, and total amount.

  const OrderHeader({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // The build method creates the UI for the OrderHeader widget.
    // It uses the order map to display the order details.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Customer: ${order['userName'] ?? 'Unknown User'}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 15),
        Text(
          "Order ID: ${order['orderId'] ?? 'N/A'}",
          style: const TextStyle(fontSize: 20),
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
