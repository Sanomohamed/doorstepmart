import 'package:flutter/material.dart';

class OrderStatusToggle extends StatelessWidget {
  final String selectedStatus;
  final Function(String) onStatusChanged;

  const OrderStatusToggle({super.key, required this.selectedStatus, required this.onStatusChanged});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> statusOptions = [
      {"label": "Pending", "icon": Icons.shopping_cart},
      {"label": "Processing", "icon": Icons.local_shipping},
      {"label": "Confirmed", "icon": Icons.check_circle},
      {"label": "Cancelled", "icon": Icons.cancel},
    ];

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
            onTap: () => onStatusChanged(status),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 28,
                  // ignore: deprecated_member_use
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
