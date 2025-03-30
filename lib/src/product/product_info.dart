import 'package:flutter/material.dart';

class ProductInfo extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductInfo({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(product['name'] ?? 'Unnamed Product',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('RM${(product['price'] as num?)?.toDouble()?.toStringAsFixed(2) ?? '0.00'}',
            style: const TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        const Text("Product Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(product['description'] ?? "No description available.", style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
