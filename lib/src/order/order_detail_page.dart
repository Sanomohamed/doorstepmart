import 'package:doorstepmart/src/order/widget/item_cart.dart';
import 'package:flutter/material.dart';

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
      body: Container(
        color: const Color.fromARGB(192, 210, 219, 214),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600), // Limit the width
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  orderData['shopName'] ?? 'Unknown Shop',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center, // Center the shop name
                ),
                const SizedBox(height: 12),
                _infoRow("Customer", orderData['userName']),
                _infoRow("Payment", orderData['paymentMethod']),
                _infoRow("Status", orderData['status']),
                _infoRow("Total", "RM${orderData['totalAmount']?.toStringAsFixed(2)}"),
                _infoRow("Date", orderData['timestamp']?.toDate()?.toString().split(".").first ?? ''),
                const SizedBox(height: 20),
                const Text(
                  "Items",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center, // Center the "Items" title
                ),
                const SizedBox(height: 10),
                ...orderItems.map((item) => ItemCard(item: item)),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title:",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            value ?? '-',
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
//need to break the code into smaller widgets for better readability and maintainability