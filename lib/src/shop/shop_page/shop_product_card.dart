import 'package:doorstepmart/src/shop/product_grid/productaction.dart';
import 'package:doorstepmart/src/shop/product_grid/productdetail.dart';
import 'package:doorstepmart/src/shop/product_grid/productimage.dart';
import 'package:flutter/material.dart';
import 'package:doorstepmart/src/product/product_detail_page.dart';
//importing the necessary packages and files
// for the ShopProductCard widget

class ShopProductCard extends StatelessWidget {
  //creating a stateless widget for the ShopProductCard
  final Map<String, dynamic> product;
  //defining the product as a final variable of type Map<String, dynamic>
  //to hold the product details

  const ShopProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    //building the widget
    //using GestureDetector to handle tap events on the card
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProductDetailPage(product: product)),
        //navigating to the ProductDetailPage when the card is tapped
        //and passing the product details to the page
      ),
      child: Card(
        //creating a card widget to display the product details
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImageSection(imageUrl: (product['imageUrls'] as List?)?.first ?? ''),
            //using the ProductImageSection widget to display the product image
            //and passing the image URL to the widget
            ProductInfoSection(product: product),
            //using the ProductInfoSection widget to display the product information
            //and passing the product details to the widget
            ProductActionsSection(product: product),
            //using the ProductActionsSection widget to display the product actions
            //and passing the product details to the widget
          ],
        ),
      ),
    );
  }
}
