import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doorstepmart/services/product.provider.dart';
import 'package:doorstepmart/src/shop/product_grid/productcart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final columnCount = screenWidth > 1000
        ? 4
        : screenWidth > 600
            ? 3
            : 2;

    if (productProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (productProvider.hasError) {
      return const Center(child: Text('Error fetching products'));
    }
    if (productProvider.products.isEmpty) {
      return const Center(child: Text('No products available'));
    }

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: GridView.builder(
            padding: EdgeInsets.zero,                // no outer padding
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnCount,
              crossAxisSpacing: 8,                  // tighter spacing
              mainAxisSpacing: 8,
              childAspectRatio: 0.75,
            ),
            itemCount: productProvider.products.length,
            itemBuilder: (context, index) {
              final product = productProvider.products[index];
              return ProductCard(product: product);
            },
          ),
        ),
      ),
    );
  }
}
