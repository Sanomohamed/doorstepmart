import 'package:doorstepmart/src/product/buttom_buttons.dart';
import 'package:doorstepmart/src/product/product_image.dart';
import 'package:doorstepmart/src/product/product_info.dart';
import 'package:doorstepmart/src/product/related_products.dart';
import 'package:doorstepmart/src/product/shop_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doorstepmart/src/shop/cart_model.dart';

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);

    // ✅ Handle imageUrls safely
    final List<dynamic>? imageUrls = product['imageUrls'] as List<dynamic>?;
    final String imageUrl = (imageUrls != null && imageUrls.isNotEmpty)
        ? imageUrls.first
        : 'https://via.placeholder.com/150';

    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductImage(imageUrl: imageUrl),
                    const SizedBox(height: 2),
                    // ✅ Add button directly under image
                    BottomButtons(product: product, cartModel: cartModel),
                    const SizedBox(height: 20),
                    ProductInfo(product: product),
                    const SizedBox(height: 20),
                    ShopInfo(shopId: product['shopId'] ?? ''),
                    const SizedBox(height: 30),
                    const RelatedProducts(),
                  ],
                ),
              ),
            ),
          ),
         // BottomButtons(product: product, cartModel: cartModel),
        ],
      ),
    );
  }
}
