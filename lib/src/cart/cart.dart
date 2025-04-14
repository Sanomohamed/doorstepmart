import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doorstepmart/src/shop/cart_model.dart';
import 'package:doorstepmart/src/cart/cart_item.dart';
import 'package:doorstepmart/src/cart/cart_summary.dart';

class CartPage extends StatelessWidget {
  final bool showBackArrow;
  const CartPage({super.key, this.showBackArrow = false});

  @override
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: _buildAppBar(context),
     backgroundColor:const Color(0xFFF8F8F8),
    body: Consumer<CartModel>(
      builder: (context, cart, child) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800), // adjust as needed
            child: Column(
              children: [
                Expanded(
                  child: cart.items.isEmpty
                      ? _buildEmptyCart()
                      : _buildCartList(cart),
                ),
                CartSummary(cart: cart),
              ],
            ),
          ),
        );
      },
    ),
  );
}
  /// App Bar
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
  /// Empty Cart View
  Widget _buildEmptyCart() {
    return const Center(
      child: Text(
        "Your cart is empty",
        style: TextStyle(fontSize: 18, color: Colors.black54),
      ),
    );
  }
  /// Cart List View
  Widget _buildCartList(CartModel cart) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: cart.items.length,
      itemBuilder: (context, index) {
        final item = cart.items[index];
        return CartItemWidget(item: item); 
      },
    );
  }
}
