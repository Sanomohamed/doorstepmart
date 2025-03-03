import 'package:flutter/material.dart';

class PaymentMethodWidget extends StatelessWidget {
  final String paymentMethod;
  final ValueChanged<String?> onChanged;

  const PaymentMethodWidget({super.key, required this.paymentMethod, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Payment Method',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        ListTile(
          title: const Text('Card'),
          leading: Radio(
            value: 'Card',
            groupValue: paymentMethod,
            activeColor: Colors.green,
            onChanged: onChanged,
          ),
        ),
        ListTile(
          title: const Text('E-Wallet'),
          leading: Radio(
            value: 'E-Wallet',
            groupValue: paymentMethod,
            activeColor: Colors.green,
            onChanged: onChanged,
          ),
        ),
        ListTile(
          title: const Text('Online Banking'),
          leading: Radio(
            value: 'Online Banking',
            groupValue: paymentMethod,
            activeColor: Colors.green,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}