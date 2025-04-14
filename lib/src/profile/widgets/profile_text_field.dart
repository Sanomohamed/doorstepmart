import 'package:flutter/material.dart';

class ProfileTextField extends StatelessWidget {
  
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?) validator;
 
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
