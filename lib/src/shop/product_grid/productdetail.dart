import 'package:flutter/material.dart';
//importing the necessary packages for the product detail page

class ProductInfoSection extends StatelessWidget {
  /// A widget that displays product information such as name, price, and shop name.
  final Map<String, dynamic> product;
  //defining the product as a final variable of type Map<String, dynamic>

  const ProductInfoSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    /// Build method to create the UI for the ProductInfoSection
    final name = product['name']?.toString() ?? 'Unknown';
    //using the null-aware operator to handle null values
    //if the name is null, it will default to 'Unknown'
    final price = (product['price'] as num?)?.toDouble() ?? 0.0;
    final shopName = product['shopName']?.toString() ?? 'Unknown Shop';

    return Padding(
      /// Padding widget to add space around the content
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Column widget to arrange the product information vertically
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
