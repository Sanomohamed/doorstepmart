import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final price = (item['price'] as num?)?.toDouble() ?? 0.0;
    final qty   = (item['quantity'] as num?)?.toInt()    ?? 0;
    final total = price * qty;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minLeadingWidth: 60, // reserve exactly 60px for the image
        leading: SizedBox(
          width: 60,
          height: 60,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item['image'] as String? ?? '',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.grey),
            ),
          ),
        ),
        title: Text(
          item['name'] as String? ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("RM${price.toStringAsFixed(2)} × $qty"),
        trailing: Text(
          "RM${total.toStringAsFixed(2)}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
