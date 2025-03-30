import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrderStatusSelector extends StatelessWidget {
  final String orderId;
  final String selectedStatus;
  final Function(String) onStatusChanged;

  const OrderStatusSelector({
    super.key,
    required this.orderId,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  static const List<Map<String, dynamic>> statusOptions = [
    {"label": "Pending", "icon": Icons.shopping_cart},
    {"label": "Processing", "icon": Icons.local_shipping},
    {"label": "Confirmed", "icon": Icons.check_circle},
    {"label": "Canceled", "icon": Icons.cancel},
  ];

  Future<void> _updateOrderStatus(String newStatus) async {
    if (newStatus == selectedStatus) return; // Avoid duplicate updates

    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
        'status': newStatus,
      });

      // Ensure Pending is cleared
      if (newStatus != "Pending") {
        await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
          'isPending': false, // Optional: Add a field to track pending status
        });
      }

      onStatusChanged(newStatus);
      Fluttertoast.showToast(msg: "Order status updated to $newStatus");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error updating status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
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
            onTap: () => _updateOrderStatus(status),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: isActive ? Colors.green.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
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
