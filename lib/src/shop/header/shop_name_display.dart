import 'package:flutter/material.dart';

class ShopNameDisplay extends StatelessWidget {
  final String shopName;

  const ShopNameDisplay({super.key, required this.shopName});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 15,
      child: Text(
        shopName,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
