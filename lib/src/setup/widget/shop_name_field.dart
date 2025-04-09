import 'package:flutter/material.dart';
//importing the necessary packages for the widget

class ShopNameField extends StatelessWidget {
  /// This widget is used to create a text field for entering the shop name.
  /// It is a stateless widget that takes a TextEditingController as a parameter.
  final TextEditingController controller;

  const ShopNameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(fontSize: 20),
      decoration: InputDecoration(
        labelText: 'Shop Name',
        labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.green, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) => value!.isEmpty ? "Enter shop name" : null,
      //validating the input to ensure that the shop name is not empty
    );
  }
}
