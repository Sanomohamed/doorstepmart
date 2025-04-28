import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doorstepmart/src/shop/cart_model.dart';
import 'package:doorstepmart/src/cart/cart_item.dart';
import 'package:doorstepmart/src/cart/cart_summary.dart';

class CartPage extends StatelessWidget {
  final bool showBackArrow;
  const CartPage({super.key, this.showBackArrow = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: const Color(0xFFF8F8F8),
      body: Consumer<CartModel>(
        builder: (context, cart, _) {
          if (cart.items.isEmpty) {
            return const Center(
              child: Text(
                "Your cart is empty",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            );
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: ListView.builder(
                padding: const EdgeInsets.only(
                  top: 8,
                  left: 8,
                  right: 8,
                  bottom: 140, // leave room for the bottom sheet
                ),
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final item = cart.items[index];
                  return CartItemWidget(item: item);
                },
              ),
            ),
          );
        },
      ),

      // ▶️ Sticky bottom summary
      bottomNavigationBar: Consumer<CartModel>(
        builder: (context, cart, _) {
          return CartSummary(cart: cart);
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('My Cart', style: TextStyle(color: Colors.black)),
      backgroundColor: Colors.white,
      elevation: 0,
      leading: showBackArrow
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            )
          : null,
    );
  }
}
