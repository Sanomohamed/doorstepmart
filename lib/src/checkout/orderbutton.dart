import 'package:flutter/material.dart';

class OrderButton extends StatelessWidget {
  const OrderButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Handle order action
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 120, 212, 123),
      ),
      child: const Text(
        'Order',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    );
  }
}