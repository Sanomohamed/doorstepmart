import 'package:doorstepmart/src/shop/product_grid/productaction.dart';
import 'package:doorstepmart/src/shop/product_grid/productdetail.dart';
import 'package:doorstepmart/src/shop/product_grid/productimage.dart';
import 'package:flutter/material.dart';
import 'package:doorstepmart/src/product/product_detail_page.dart';

class ShopProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const ShopProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProductDetailPage(product: product)),
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImageSection(imageUrl: (product['imageUrls'] as List?)?.first ?? ''),
            ProductInfoSection(product: product),
            ProductActionsSection(product: product),
          ],
        ),
      ),
    );
  }
}
