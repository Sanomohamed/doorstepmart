// 📄 bottom_buttons.dart
import 'package:doorstepmart/src/product/widgets/view_cart_toast.dart';
import 'package:doorstepmart/src/shop/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomButtons extends StatelessWidget {
  final Map<String, dynamic> product;
  final CartModel? cartModel;

  const BottomButtons({super.key, required this.product, this.cartModel});

  @override
  Widget build(BuildContext context) {
    final cart = cartModel ?? Provider.of<CartModel>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ElevatedButton.icon(
          onPressed: () {
            final newItem = CartItem(
              name: product['name'] ?? 'Unnamed Product',
              image: (product['imageUrls'] as List<dynamic>?)?.firstOrNull ?? '',
              price: (product['price'] as num?)?.toDouble() ?? 0.0,
              shopId: product['shopId'] ?? '',
              shopName: product['shopName'] ?? 'Unknown Shop',
              quantity: 1,
            );

            cart.add(newItem);

            showViewCartToastBottomSheet(
              context: context,
              productName: newItem.name,
            );
          },
          icon: const Icon(Icons.add_shopping_cart, size: 18,color: Colors.white),
          label: const Text(
            "Add to Cart",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            minimumSize: const Size(10, 40), // Smaller button
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textStyle: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}
