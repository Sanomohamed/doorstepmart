import 'package:flutter/material.dart';

class PurchaseSection extends StatelessWidget {
  const PurchaseSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My Purchase',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text('View Purchase History'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            // Handle view purchase history action
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  iconSize: 50.0,
                  onPressed: () {
                    // Handle orders action
                  },
                ),
                const Text('Orders'),
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.local_shipping),
                  iconSize: 50.0,
                  onPressed: () {
                    // Handle received action
                  },
                ),
                const Text('Received'),
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.check_circle),
                  iconSize: 50.0,
                  onPressed: () {
                    // Handle completed action
                  },
                ),
                const Text('Completed'),
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.cancel),
                  iconSize: 50.0,
                  onPressed: () {
                    // Handle canceled action
                  },
                ),
                const Text('Canceled'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}