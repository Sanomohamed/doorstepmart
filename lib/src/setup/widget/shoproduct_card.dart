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
    final imageUrl = (product['imageUrls'] as List?)?.first
            ?? 'https://via.placeholder.com/150';
    final name = product['name'] ?? 'Unnamed';
    final price = product['price'] ?? 0.0;

    return Card(
      margin: EdgeInsets.zero,  // remove default Card margin
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      clipBehavior: Clip.antiAlias, 
      child: Column(
        children: [
          // image takes up available space
          Expanded(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),

          // metadata & actions, no padding
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // name
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // price
              Text(
                'RM${price.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.green),
              ),

              // edit/delete row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,       // remove button padding
                    constraints: const BoxConstraints(), 
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete, color: Colors.red),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
