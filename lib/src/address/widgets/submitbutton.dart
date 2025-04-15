import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final bool isLoading;
  final bool isEditing;
  final VoidCallback onPressed;

  const SubmitButton({
    super.key,
    required this.isLoading,
    required this.isEditing,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : Text(
              isEditing ? "Update Address" : "Save Address",
              style: const TextStyle(fontSize: 18),
            ),
    );
  }
}