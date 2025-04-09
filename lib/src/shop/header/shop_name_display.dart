import 'package:flutter/material.dart';
//importing the necessary packages for the widget

class ShopNameDisplay extends StatelessWidget {
  // This widget is used to display the shop name on the screen.
  // It is a stateless widget that takes the shop name as a parameter.
  final String shopName;

  const ShopNameDisplay({super.key, required this.shopName});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      // The build method returns a Positioned widget that contains a Text widget.
      // The Positioned widget is used to place the Text widget at a specific location on the screen.
      // The Text widget displays the shop name with a specific style.
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
