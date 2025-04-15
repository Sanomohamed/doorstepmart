import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            // Add your onPressed code here!
          },
          child: Container(
            color: Colors.transparent, // Ensures the entire area is clickable
            child: Row(
              children: [
                const Icon(
                  Icons.visibility,
                  color: Color.fromARGB(255, 46, 45, 45),
                ),
                const SizedBox(width: 5), // Space between icon and text
                const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Color.fromARGB(255, 54, 53, 53),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}