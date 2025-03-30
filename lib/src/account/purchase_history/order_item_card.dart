import 'package:flutter/material.dart';

class OrderItemCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const OrderItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Image.network(item['image'], width: 50, height: 50, fit: BoxFit.cover),
        title: Text(item['name']),
        subtitle: Text("RM${item['price']} x ${item['quantity']}"),
        trailing: Text("RM${(item['price'] * item['quantity']).toStringAsFixed(2)}"),
      ),
    );
  }
}
