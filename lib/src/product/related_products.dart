import 'package:doorstepmart/src/shop/product_grid/productgrid.dart';
import 'package:flutter/material.dart';

class RelatedProducts extends StatelessWidget {
  const RelatedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text("More Products", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        ProductGrid(),
      ],
    );
  }
}
