import 'package:flutter/material.dart';

InputDecoration inputDecoration(String label, IconData icon) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.green, width: 2),
      borderRadius: BorderRadius.circular(15),
    ),
  );
}

ButtonStyle buttonStyle(Color color) {
  return ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: color,
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 90),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    elevation: 5,
  );
}
