import 'package:flutter/material.dart';
import 'package:doorstepmart/src/shop/cart_model.dart';
import 'package:provider/provider.dart';

class BottomButtons extends StatelessWidget {
  final Map<String, dynamic> product;
  final CartModel cartModel;

  const BottomButtons({super.key, required this.product, required this.cartModel});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  cartModel.add(
                    CartItem(
                      name: product['name'] ?? 'Unnamed Product',
                      image: (product['imageUrls'] as List<dynamic>?)?.firstOrNull ?? '',
                      price: (product['price'] as num?)?.toDouble() ?? 0.0,
                      shopId: product['shopId'] ?? '',
                      shopName: 'Unknown Shop', // shopName will be handled later
                      quantity: 1,
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product['name']} added to cart'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text("Add to Cart"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
