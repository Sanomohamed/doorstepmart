import 'package:flutter/material.dart';
import 'package:doorstepmart/src/shop/productgrid.dart';

class ProductGridSection extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const ProductGridSection({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return ProductGrid(products: products);
  }
}