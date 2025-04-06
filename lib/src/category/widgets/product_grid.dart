import 'package:doorstepmart/src/category/widgets/product_cart.dart';
import 'package:flutter/material.dart';

class ProductGrid extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final double horizontalPadding;

  const ProductGrid({
    super.key,
    required this.products,
    required this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(child: Text('No products available'));
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 10),
          child: GridView.builder(
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              return ProductCard(product: products[index]);
            },
          ),
        ),
      ),
    );
  }
}
