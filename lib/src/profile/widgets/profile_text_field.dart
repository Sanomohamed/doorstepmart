import 'package:flutter/material.dart';
//importing necessary packages

class ProfileTextField extends StatelessWidget {
  //creating a stateless widget for the profile text field
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?) validator;
  //defining the required parameters for the text field
  //controller for the text field, label for the text field, icon for the text field, and validator function

  const ProfileTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.green, width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      validator: validator,
    );
  }
}
