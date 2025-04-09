import 'package:doorstepmart/src/shop/product_grid/productaction.dart';
import 'package:doorstepmart/src/shop/product_grid/productdetail.dart';
import 'package:doorstepmart/src/shop/product_grid/productimage.dart';
import 'package:flutter/material.dart';
import 'package:doorstepmart/src/product/product_detail_page.dart';
//importing the necessary packages and files

class ProductCard extends StatelessWidget {
  /// A widget that represents a product card in the product grid.
  final Map<String, dynamic> product;
  //defining the product as a final variable of type Map<String, dynamic>
  //to hold the product details
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    /// Build method to create the UI for the ProductCard
    /// using the GestureDetector to handle tap events
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => ProductDetailPage(product: product),
        ));
      },
      child: Card(
        /// Card widget to create a material design card
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
