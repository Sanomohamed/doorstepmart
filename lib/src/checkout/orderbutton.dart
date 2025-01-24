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
        backgroundColor: const Color.fromARGB(255, 110, 146, 111),
      ),
      child: const Text(
        'Order',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}