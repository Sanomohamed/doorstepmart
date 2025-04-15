import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ShopProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ShopProductCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = (product['imageUrls'] as List?)?.first ?? 'https://via.placeholder.com/150';
    final name = product['name'] ?? 'Unnamed';
    final price = product['price'] ?? 0.0;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('RM${price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.green)),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: onEdit, icon: const Icon(Icons.edit, color: Colors.blue)),
                    IconButton(onPressed: onDelete, icon: const Icon(Icons.delete, color: Colors.red)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
