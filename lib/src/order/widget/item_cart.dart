import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(item['image'], width: 50, height: 50, fit: BoxFit.cover),
        ),
        title: Text(item['name'] ?? ''),
        subtitle: Text("RM${item['price']} x ${item['quantity']}"),
        trailing: Text("RM${(item['price'] * item['quantity']).toStringAsFixed(2)}"),
      ),
    );
  }
}
