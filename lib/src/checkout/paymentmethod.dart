import 'package:flutter/material.dart';

class PaymentMethod extends StatelessWidget {
  final String paymentMethod;
  final Function(String?) onChanged;

  const PaymentMethod({
    super.key,
    required this.paymentMethod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Payment Method',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        ListTile(
          title: const Text('Card'),
          leading: Radio(
            value: 'Card',
            groupValue: paymentMethod,
            onChanged: onChanged,
          ),
        ),
        ListTile(
          title: const Text('E-Wallet'),
          leading: Radio(
            value: 'E-Wallet',
            groupValue: paymentMethod,
            onChanged: onChanged,
          ),
        ),
        ListTile(
          title: const Text('Online Banking'),
          leading: Radio(
            value: 'Online Banking',
            groupValue: paymentMethod,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}