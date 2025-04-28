import 'package:flutter/material.dart';

class OrderItemList extends StatelessWidget {
  final List<dynamic> items;

  const OrderItemList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final price = (item['price'] as num?)?.toDouble() ?? 0.0;
        final qty   = (item['quantity'] as num?)?.toInt()    ?? 1;
        final total = price * qty;

        return Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minLeadingWidth: 80,
              leading: SizedBox(
                width: 80,
                height: 80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item['image'] as String? ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                ),
              ),
              title: Text(
                item['name'] as String? ?? 'Unknown Item',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text(
                'RM${price.toStringAsFixed(2)} × $qty',
                style:
                    const TextStyle(color: Colors.black54, fontSize: 14),
              ),
              trailing: Text(
                'RM${total.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        );
      },
    );
  }
}
