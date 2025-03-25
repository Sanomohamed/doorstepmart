import 'package:doorstepmart/src/order/order.dart';
import 'package:doorstepmart/src/shop/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomBarWidget extends StatelessWidget {
  final double grandTotalWithDiscount;
  final String paymentMethod; // ✅ added

  const BottomBarWidget({
    super.key,
    required this.grandTotalWithDiscount,
    required this.paymentMethod, // ✅ added
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Payment:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              Text(
                'RM${grandTotalWithDiscount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () async {
              final cartModel = Provider.of<CartModel>(context, listen: false);
              if (cartModel.items.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Cart is empty")),
                );
                return;
              }

              await placeOrder(
                context: context,
                cartItems: cartModel.items,
                total: grandTotalWithDiscount,
                paymentMethod: paymentMethod, // ✅ use passed method
              );

              cartModel.clearCart(); // 🧹 Clear after placing order
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
            ),
            child: const Row(
              children: [
                Icon(Icons.shopping_cart_checkout, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'Place Order',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
