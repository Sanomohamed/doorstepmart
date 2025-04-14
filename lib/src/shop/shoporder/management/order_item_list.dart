import 'package:flutter/material.dart';

class OrderItemList extends StatelessWidget {
  final List<dynamic> items;

  const OrderItemList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(

      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
    
        return Padding(
          padding: const EdgeInsets.only(bottom: 18), 
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              leading: ClipRRect(// ClipRRect is used to create rounded corners for the image.
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item['image'] ?? '',
                  width: 80,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported),
                ),
              ),
              title: Text(
                item['name'] ?? 'Unknown Item',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              subtitle: Text(
                'RM${item['price'] ?? 0} x ${item['quantity'] ?? 1}',
                style: const TextStyle(color: Colors.black54, fontSize: 16),
              ),
            ),
          ),
        );
      },
    );
  }
}
