import 'package:flutter/material.dart';
class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.obscureText = false,
    required this.controller,
  });

@override
Widget build(BuildContext context) {
  return TextField(
    controller: controller,
    obscureText: obscureText,
    style: TextStyle(fontSize: 22, color: Colors.black87), 
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: const Color.fromARGB(197, 0, 0, 0)), 
      filled: true,
      fillColor: const Color.fromARGB(172, 238, 238, 238), 
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30), 
        border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25), 
        borderSide: BorderSide.none,
      ),
        focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: const Color.fromARGB(255, 105, 133, 106), width: 2), 
      ),
        enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: const Color.fromARGB(129, 227, 250, 221)), 
      ),
    ),
  );
}
}