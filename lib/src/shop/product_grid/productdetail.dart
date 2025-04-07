import 'package:flutter/material.dart';

class ProductInfoSection extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductInfoSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final name = product['name']?.toString() ?? 'Unknown';
    final price = (product['price'] as num?)?.toDouble() ?? 0.0;
    final shopName = product['shopName']?.toString() ?? 'Unknown Shop';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('RM${price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
          Text(shopName, style: const TextStyle(fontSize: 14, color: Colors.blue)),
        ],
      ),
    );
  }
}
