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
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 5,
                spreadRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildPaymentOption('Card', Icons.credit_card, context),
              _buildPaymentOption('E-Wallet', Icons.account_balance_wallet, context),
              _buildPaymentOption('Online Banking', Icons.account_balance, context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption(String title, IconData icon, BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      leading: Icon(icon, color: Colors.green),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: Radio(
        value: title,
        groupValue: paymentMethod,
        activeColor: Colors.green,
        onChanged: onChanged,
      ),
    );
  }
}
