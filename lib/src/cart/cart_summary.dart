import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:doorstepmart/src/shop/cart_model.dart';
import 'package:doorstepmart/src/checkout/checkout_page.dart';

class CartSummary extends StatelessWidget {
  final CartModel cart;
  const CartSummary({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 5, blurRadius: 7, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          _buildSubtotal(),
          const SizedBox(height: 10),
          _buildCheckoutButton(context),
        ],
      ),
    );
  }

  /// Subtotal Row
  Widget _buildSubtotal() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Subtotal:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text('RM${cart.totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
      ],
    );
  }

  ///Checkout Button
  Widget _buildCheckoutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: cart.items.isEmpty
          ? () {
              Fluttertoast.showToast(msg: "Add items to the cart to checkout", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 16.0);
            }
          : () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutPage()));
            },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 100), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
      child: const Text('Check Out', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }
}
