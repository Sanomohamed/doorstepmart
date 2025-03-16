import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.visibility),
          color: const Color.fromARGB(255, 46, 45, 45),
          onPressed: () {
            // Add your onPressed code here!
          },
        ),
        const Text(
          'Forgot Password?',
          style: TextStyle(
            color: Color.fromARGB(255, 54, 53, 53),
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      ],
    );
  }
}