import 'package:flutter/material.dart';

class PromoCodeWidget extends StatelessWidget {
  final TextEditingController promoCodeController;
  final VoidCallback applyPromoCode;

  const PromoCodeWidget({super.key, required this.promoCodeController, required this.applyPromoCode});

  @override
  Widget build(BuildContext context) {
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
          onPressed: applyPromoCode,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 102, 230, 106),
          ),
          child: const Text(
            'Apply',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}