import 'package:doorstepmart/src/shop/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class PromoCode extends StatelessWidget {
  final TextEditingController promoCodeController;
  final Function(CartModel) applyPromoCode;

  const PromoCode({
    super.key,
    required this.promoCodeController,
    required this.applyPromoCode,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: promoCodeController,
          decoration: const InputDecoration(
            labelText: 'Coupon or Promo Code',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: () {
            applyPromoCode(cart);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 110, 146, 111),
          ),
          child: const Text(
            'Apply',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}