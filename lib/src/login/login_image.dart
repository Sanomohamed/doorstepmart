import 'package:flutter/material.dart';

class LoginImage extends StatelessWidget {
  const LoginImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      width: 500,
      height: 300,
      decoration: BoxDecoration(
        color: const Color(0xFFD2DBD6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Image.asset(
        'assets/image.png', // Replace with your image path
        height: 100,
        fit: BoxFit.fill,
      ),
    );
  }
}