import 'package:flutter/material.dart';
//importing the necessary packages for the order item list

class OrderItemList extends StatelessWidget {
  // Defining the OrderItemList widget which is a StatelessWidget
  // This widget is used to display a list of items in an order.
  final List<dynamic> items;


  const OrderItemList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    // The build method creates the UI for the OrderItemList widget.
    return ListView.builder(
        // Creates a scrollable list of items using ListView.builder
      itemCount: items.length,
      itemBuilder: (context, index) {
        // The itemBuilder function is called for each item in the list.
        // It takes the context and the index of the item as parameters.
        final item = items[index];
        // Retrieves the item from the items list using the index.
        // The item is expected to be a map containing details about the item such as name, image, price, and quantity.
        return Padding(
          padding: const EdgeInsets.only(bottom: 18), 
          child: Card(
            // Creates a card widget to display the item details.
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              leading: ClipRRect(
                // ClipRRect is used to create rounded corners for the image.
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  // Displays the image of the item using Image.network.
                  // The image URL is retrieved from the item map using the key 'image'.
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
