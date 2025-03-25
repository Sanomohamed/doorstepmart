import 'package:doorstepmart/src/account/purchase_history.dart';
import 'package:flutter/material.dart';

class PurchaseSection extends StatelessWidget {
  const PurchaseSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
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
            // ✅ Section Title
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

            // ✅ Purchase History Option
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              leading: CircleAvatar(
                radius: 28,
                // ignore: deprecated_member_use
                backgroundColor: Colors.blueAccent.withOpacity(0.2),
                child: const Icon(Icons.history, color: Colors.blueAccent, size: 28),
              ),
              title: const Text(
                'View Purchase History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Color.fromARGB(158, 0, 0, 0)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: Colors.white,
              onTap: () {
                Navigator.push(
                             context,
                         MaterialPageRoute(builder: (context) => const PurchaseHistoryPage()),
             );
              },
            ),

            const SizedBox(height: 12),

            // ✅ Purchase Status Grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPurchaseItem(Icons.shopping_cart, "Orders", Colors.green),
                _buildPurchaseItem(Icons.local_shipping, "Received", Colors.orange),
                _buildPurchaseItem(Icons.check_circle, "Completed", Colors.blue),
                _buildPurchaseItem(Icons.cancel, "Canceled", Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Modernized Button with Uniform Design
  Widget _buildPurchaseItem(IconData icon, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          // ignore: deprecated_member_use
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, size: 30, color: color),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
