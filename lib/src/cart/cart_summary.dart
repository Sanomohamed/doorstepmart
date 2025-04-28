import 'package:flutter/material.dart';
import 'package:doorstepmart/src/shop/cart_model.dart';
import 'package:doorstepmart/src/checkout/checkout_page.dart';

class CartSummary extends StatelessWidget {
  final CartModel cart;
  const CartSummary({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    final subtotal = cart.totalPrice;
    final isDisabled = subtotal <= 0;

    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Subtotal Row
            Row(
              children: [
                const Text(
                  'Subtotal:',
                  style: TextStyle(fontSize: 18),
                ),
                const Spacer(),
                Text(
                  'RM${subtotal.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDisabled ? Colors.grey : Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Check Out button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isDisabled
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CheckoutPage(),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDisabled ? Colors.grey[300] : Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Check Out',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDisabled ? Colors.white70 : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
