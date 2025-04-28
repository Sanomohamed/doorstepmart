import 'package:doorstepmart/src/order/purchase_history_page.dart';
import 'package:flutter/material.dart';

class PurchaseSection extends StatelessWidget {
  const PurchaseSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Card(
          elevation: 40,
          margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8, bottom: 10),
                  child: Text(
                    'My Purchase',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

                // View all history
                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.blueAccent.withOpacity(0.2),
                    child:
                        const Icon(Icons.history, color: Colors.blueAccent, size: 28),
                  ),
                  title: const Text(
                    'View Purchase History',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  tileColor: Colors.white,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PurchaseHistoryPage(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildPurchaseItem(context,
                        icon: Icons.shopping_cart,
                        label: "Orders",
                        color: Colors.green),
                    _buildPurchaseItem(context,
                        icon: Icons.local_shipping,
                        label: "Received",
                        color: Colors.orange),
                    _buildPurchaseItem(context,
                        icon: Icons.check_circle,
                        label: "Confirmed",
                        color: Colors.blue),
                    _buildPurchaseItem(context,
                        icon: Icons.cancel, label: "Canceled", color: Colors.red),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPurchaseItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    // map your UI label to the Firestore status string
    final status = {
      'Orders': 'Pending',
      'Received': 'Processing',
      'Confirmed': 'Confirmed',
      'Canceled': 'Canceled',
    }[label]!;

    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PurchaseHistoryPage(initialStatus: status),
          ),
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, size: 30, color: color),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
